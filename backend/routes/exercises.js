const express = require('express');
const { v4: uuidv4 } = require('uuid');
const { authenticate, requireRole } = require('../middleware/auth');
const store = require('../data/store');

const router = express.Router();
const MANAGER_ROLES = ['ADMIN', 'TEACHER'];

// GET /exercises (filter by lessonId)
router.get('/', (req, res) => {
  const { lessonId } = req.query;
  let results = [...store.exercises];
  if (lessonId) results = results.filter((e) => e.lessonId === lessonId);
  res.json(results);
});

// GET /exercises/:id
router.get('/:id', (req, res) => {
  const exercise = store.exercises.find((e) => e.id === req.params.id);
  if (!exercise) return res.status(404).json({ message: 'Exercise not found' });
  res.json(exercise);
});

// POST /exercises - Admin/Teacher
router.post('/', authenticate, requireRole(...MANAGER_ROLES), (req, res) => {
  const { lessonId, type, question, options, correctAnswer, orderIndex } = req.body;
  if (!lessonId || !question || !correctAnswer) return res.status(400).json({ message: 'lessonId, question, and correctAnswer are required' });
  const newExercise = {
    id: uuidv4(),
    lessonId,
    type: type || 'MULTIPLE_CHOICE',
    question,
    options: Array.isArray(options) ? options : [],
    correctAnswer,
    orderIndex: orderIndex || (store.exercises.filter((e) => e.lessonId === lessonId).length + 1),
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };
  store.exercises.push(newExercise);
  res.status(201).json(newExercise);
});

// PUT /exercises/:id - Admin/Teacher
router.put('/:id', authenticate, requireRole(...MANAGER_ROLES), (req, res) => {
  const idx = store.exercises.findIndex((e) => e.id === req.params.id);
  if (idx === -1) return res.status(404).json({ message: 'Exercise not found' });
  ['type', 'question', 'options', 'correctAnswer', 'orderIndex'].forEach((f) => {
    if (req.body[f] !== undefined) store.exercises[idx][f] = req.body[f];
  });
  store.exercises[idx].updatedAt = new Date().toISOString();
  res.json(store.exercises[idx]);
});

// DELETE /exercises/:id - Admin/Teacher
router.delete('/:id', authenticate, requireRole(...MANAGER_ROLES), (req, res) => {
  const idx = store.exercises.findIndex((e) => e.id === req.params.id);
  if (idx === -1) return res.status(404).json({ message: 'Exercise not found' });
  store.exercises.splice(idx, 1);
  res.json({ message: 'Exercise deleted' });
});

module.exports = router;
