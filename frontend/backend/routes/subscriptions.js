const express = require('express');
const { v4: uuidv4 } = require('uuid');
const { authenticate } = require('../middleware/auth');
const store = require('../data/store');

const router = express.Router();

// GET /subscriptions/status - Authenticated
router.get('/status', authenticate, (req, res) => {
  const subscription = store.subscriptions.find(
    (s) => s.userId === req.user.id && s.status === 'ACTIVE'
  );
  if (!subscription) {
    return res.json({ hasActiveSubscription: false, plan: null, subscription: null });
  }
  const plan = store.subscriptionPlans.find((p) => p.id === subscription.planId);
  res.json({
    hasActiveSubscription: true,
    plan: plan || null,
    subscription,
  });
});

// GET /subscriptions - Admin only
router.get('/', authenticate, (req, res) => {
  if (req.user.role !== 'ADMIN') return res.status(403).json({ message: 'Admin only' });
  res.json(store.subscriptions);
});

// POST /subscriptions - Authenticated (subscribe to a plan)
router.post('/', authenticate, (req, res) => {
  const { planId } = req.body;
  if (!planId) return res.status(400).json({ message: 'planId is required' });
  const plan = store.subscriptionPlans.find((p) => p.id === planId);
  if (!plan) return res.status(404).json({ message: 'Plan not found' });
  if (!plan.isActive) return res.status(400).json({ message: 'Plan is not active' });
  // Cancel existing active subscription
  const existingIdx = store.subscriptions.findIndex(
    (s) => s.userId === req.user.id && s.status === 'ACTIVE'
  );
  if (existingIdx !== -1) store.subscriptions[existingIdx].status = 'EXPIRED';
  const endDate = new Date(Date.now() + plan.durationDays * 86400000).toISOString();
  const newSub = {
    id: uuidv4(),
    userId: req.user.id,
    planId,
    status: 'ACTIVE',
    startDate: new Date().toISOString(),
    endDate,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };
  store.subscriptions.push(newSub);
  res.status(201).json(newSub);
});

// DELETE /subscriptions/cancel - Authenticated
router.delete('/cancel', authenticate, (req, res) => {
  const idx = store.subscriptions.findIndex(
    (s) => s.userId === req.user.id && s.status === 'ACTIVE'
  );
  if (idx === -1) return res.status(404).json({ message: 'No active subscription found' });
  store.subscriptions[idx].status = 'CANCELLED';
  store.subscriptions[idx].updatedAt = new Date().toISOString();
  res.json({ message: 'Subscription cancelled', subscription: store.subscriptions[idx] });
});

module.exports = router;
