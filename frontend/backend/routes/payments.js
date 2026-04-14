const express = require('express');
const { v4: uuidv4 } = require('uuid');
const { authenticate } = require('../middleware/auth');
const store = require('../data/store');

const router = express.Router();

// GET /payments/history - Authenticated
router.get('/history', authenticate, (req, res) => {
  const userPayments = store.payments.filter((p) => p.userId === req.user.id);
  res.json(userPayments);
});

// POST /payments/create - Authenticated (mock payment)
router.post('/create', authenticate, (req, res) => {
  const { planId, paymentMethod } = req.body;
  if (!planId) return res.status(400).json({ message: 'planId is required' });
  const plan = store.subscriptionPlans.find((p) => p.id === planId);
  if (!plan) return res.status(404).json({ message: 'Plan not found' });
  const payment = {
    id: uuidv4(),
    userId: req.user.id,
    planId,
    amount: plan.price,
    currency: plan.currency,
    status: plan.price === 0 ? 'COMPLETED' : 'PENDING',
    paymentMethod: paymentMethod || 'VNPAY',
    transactionId: `TXN_${uuidv4().split('-')[0].toUpperCase()}`,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };
  store.payments.push(payment);
  res.status(201).json(payment);
});

// GET /payments - Admin only
router.get('/', authenticate, (req, res) => {
  if (req.user.role !== 'ADMIN') return res.status(403).json({ message: 'Admin only' });
  res.json(store.payments);
});

module.exports = router;
