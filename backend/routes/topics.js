const express = require('express');
const { v4: uuidv4 } = require('uuid');
const { authenticate, requireRole } = require('../middleware/auth');
const store = require('../data/store');

const router = express.Router();

// GET /topics - Public
router.get('/', (req, res) => {
  res.json(store.topics);
});

// GET /topics/:id - Public
router.get('/:id', (req, res) => {
  const topic = store.topics.find((t) => t.id === req.params.id);
  if (!topic) return res.status(404).json({ message: 'Topic not found' });
  res.json(topic);
});

// GET /topics/:id/courses - Public
router.get('/:id/courses', (req, res) => {
  const courses = store.courses.filter((c) => c.topicId === req.params.id);
  res.json(courses);
});

// POST /topics - Admin only
router.post('/', authenticate, requireRole('ADMIN'), (req, res) => {
  const { name, description, iconUrl, isActive } = req.body;
  if (!name) return res.status(400).json({ message: 'Name is required' });
  const newTopic = {
    id: uuidv4(),
    name,
    description: description || '',
    iconUrl: iconUrl || null,
    isActive: isActive !== undefined ? isActive : true,
    orderIndex: store.topics.length + 1,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };
  store.topics.push(newTopic);
  res.status(201).json(newTopic);
});

// PUT /topics/:id - Admin only
router.put('/:id', authenticate, requireRole('ADMIN'), (req, res) => {
  const idx = store.topics.findIndex((t) => t.id === req.params.id);
  if (idx === -1) return res.status(404).json({ message: 'Topic not found' });
  const { name, description, iconUrl, isActive, orderIndex } = req.body;
  store.topics[idx] = {
    ...store.topics[idx],
    name: name !== undefined ? name : store.topics[idx].name,
    description: description !== undefined ? description : store.topics[idx].description,
    iconUrl: iconUrl !== undefined ? iconUrl : store.topics[idx].iconUrl,
    isActive: isActive !== undefined ? isActive : store.topics[idx].isActive,
    orderIndex: orderIndex !== undefined ? orderIndex : store.topics[idx].orderIndex,
    updatedAt: new Date().toISOString(),
  };
  res.json(store.topics[idx]);
});

// DELETE /topics/:id - Admin only
router.delete('/:id', authenticate, requireRole('ADMIN'), (req, res) => {
  const idx = store.topics.findIndex((t) => t.id === req.params.id);
  if (idx === -1) return res.status(404).json({ message: 'Topic not found' });
  store.topics.splice(idx, 1);
  res.json({ message: 'Topic deleted' });
});

module.exports = router;
