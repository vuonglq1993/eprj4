const express = require('express');
const { v4: uuidv4 } = require('uuid');
const { authenticate, requireRole } = require('../middleware/auth');
const store = require('../data/store');

const router = express.Router();

// GET /subscription-plans - Public
router.get('/', (req, res) => {
  const { isActive } = req.query;
  let results = [...store.subscriptionPlans];
  if (isActive !== undefined) {
    results = results.filter((p) => p.isActive === (isActive === 'true'));
  }
  res.json(results);
});

// GET /subscription-plans/:id - Public
router.get('/:id', (req, res) => {
  const plan = store.subscriptionPlans.find((p) => p.id === req.params.id);
  if (!plan) return res.status(404).json({ message: 'Plan not found' });
  res.json(plan);
});

// POST /subscription-plans - Admin only
router.post('/', authenticate, requireRole('ADMIN'), (req, res) => {
  const { name, description, price, currency, durationDays, features, isActive } = req.body;
  if (!name) return res.status(400).json({ message: 'Name is required' });
  const newPlan = {
    id: uuidv4(),
    name,
    description: description || '',
    price: price || 0,
    currency: currency || 'VND',
    durationDays: durationDays || 30,
    features: Array.isArray(features) ? features : [],
    isActive: isActive !== undefined ? isActive : true,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };
  store.subscriptionPlans.push(newPlan);
  res.status(201).json(newPlan);
});

// PUT /subscription-plans/:id - Admin only
router.put('/:id', authenticate, requireRole('ADMIN'), (req, res) => {
  const idx = store.subscriptionPlans.findIndex((p) => p.id === req.params.id);
  if (idx === -1) return res.status(404).json({ message: 'Plan not found' });
  const { name, description, price, currency, durationDays, features, isActive } = req.body;
  store.subscriptionPlans[idx] = {
    ...store.subscriptionPlans[idx],
    name: name !== undefined ? name : store.subscriptionPlans[idx].name,
    description: description !== undefined ? description : store.subscriptionPlans[idx].description,
    price: price !== undefined ? price : store.subscriptionPlans[idx].price,
    currency: currency !== undefined ? currency : store.subscriptionPlans[idx].currency,
    durationDays: durationDays !== undefined ? durationDays : store.subscriptionPlans[idx].durationDays,
    features: features !== undefined ? (Array.isArray(features) ? features : store.subscriptionPlans[idx].features) : store.subscriptionPlans[idx].features,
    isActive: isActive !== undefined ? isActive : store.subscriptionPlans[idx].isActive,
    updatedAt: new Date().toISOString(),
  };
  res.json(store.subscriptionPlans[idx]);
});

// PATCH /subscription-plans/:id/toggle - Admin only
router.patch('/:id/toggle', authenticate, requireRole('ADMIN'), (req, res) => {
  const idx = store.subscriptionPlans.findIndex((p) => p.id === req.params.id);
  if (idx === -1) return res.status(404).json({ message: 'Plan not found' });
  store.subscriptionPlans[idx].isActive = !store.subscriptionPlans[idx].isActive;
  store.subscriptionPlans[idx].updatedAt = new Date().toISOString();
  res.json(store.subscriptionPlans[idx]);
});

// DELETE /subscription-plans/:id - Admin only
router.delete('/:id', authenticate, requireRole('ADMIN'), (req, res) => {
  const idx = store.subscriptionPlans.findIndex((p) => p.id === req.params.id);
  if (idx === -1) return res.status(404).json({ message: 'Plan not found' });
  store.subscriptionPlans.splice(idx, 1);
  res.json({ message: 'Plan deleted' });
});

module.exports = router;
