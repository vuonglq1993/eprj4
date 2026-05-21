const express = require('express');
const { v4: uuidv4 } = require('uuid');
const { authenticate, requireRole } = require('../middleware/auth');
const store = require('../data/store');

const router = express.Router();
const MANAGER_ROLES = ['ADMIN'];

// GET /courses
router.get('/', (req, res) => {
  const { languageId, topicId, targetLevel, isPublished } = req.query;
  let results = [...store.courses];
  if (languageId) results = results.filter((c) => c.languageId === languageId);
  if (topicId) results = results.filter((c) => c.topicId === topicId);
  if (targetLevel) results = results.filter((c) => c.targetLevel === targetLevel);
  if (isPublished !== undefined) results = results.filter((c) => c.isPublished === (isPublished === 'true'));
  res.json(results);
});

// GET /courses/:id
router.get('/:id', (req, res) => {
  const course = store.courses.find((c) => c.id === req.params.id);
  if (!course) return res.status(404).json({ message: 'Course not found' });
  res.json(course);
});

// POST /courses - Admin/Teacher
router.post('/', authenticate, requireRole(...MANAGER_ROLES), (req, res) => {
  const { title, description, languageId, topicId, targetLevel, price, durationMinutes } = req.body;
  if (!title) return res.status(400).json({ message: 'Title is required' });
  const newCourse = {
    id: uuidv4(),
    title,
    description: description || '',
    languageId: languageId || null,
    topicId: topicId || null,
    targetLevel: targetLevel || 'BEGINNER',
    price: price || 0,
    isPublished: false,
    durationMinutes: durationMinutes || 0,
    lessonsCount: 0,
    creatorId: req.user.id,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };
  store.courses.push(newCourse);
  res.status(201).json(newCourse);
});

// PUT /courses/:id - Admin/Teacher
router.put('/:id', authenticate, requireRole(...MANAGER_ROLES), (req, res) => {
  const idx = store.courses.findIndex((c) => c.id === req.params.id);
  if (idx === -1) return res.status(404).json({ message: 'Course not found' });
  const fields = ['title', 'description', 'languageId', 'topicId', 'targetLevel', 'price', 'isPublished', 'durationMinutes'];
  fields.forEach((f) => {
    if (req.body[f] !== undefined) store.courses[idx][f] = req.body[f];
  });
  store.courses[idx].updatedAt = new Date().toISOString();
  res.json(store.courses[idx]);
});

// PATCH /courses/:id/publish - Admin/Teacher
router.patch('/:id/publish', authenticate, requireRole(...MANAGER_ROLES), (req, res) => {
  const idx = store.courses.findIndex((c) => c.id === req.params.id);
  if (idx === -1) return res.status(404).json({ message: 'Course not found' });
  store.courses[idx].isPublished = !store.courses[idx].isPublished;
  store.courses[idx].updatedAt = new Date().toISOString();
  res.json(store.courses[idx]);
});

// DELETE /courses/:id - Admin/Teacher
router.delete('/:id', authenticate, requireRole(...MANAGER_ROLES), (req, res) => {
  const idx = store.courses.findIndex((c) => c.id === req.params.id);
  if (idx === -1) return res.status(404).json({ message: 'Course not found' });
  store.courses.splice(idx, 1);
  store.lessons = store.lessons.filter((l) => l.courseId !== req.params.id);
  res.json({ message: 'Course deleted' });
});

module.exports = router;
