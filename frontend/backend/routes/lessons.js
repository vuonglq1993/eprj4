const express = require('express');
const { v4: uuidv4 } = require('uuid');
const { authenticate, requireRole } = require('../middleware/auth');
const store = require('../data/store');

const router = express.Router();
const MANAGER_ROLES = ['ADMIN'];

// GET /lessons (filter by courseId)
router.get('/', (req, res) => {
  const { courseId } = req.query;
  let results = [...store.lessons];
  if (courseId) results = results.filter((l) => l.courseId === courseId);
  res.json(results);
});

// GET /lessons/:id
router.get('/:id', (req, res) => {
  const lesson = store.lessons.find((l) => l.id === req.params.id);
  if (!lesson) return res.status(404).json({ message: 'Lesson not found' });
  res.json(lesson);
});

// POST /lessons - Admin/Teacher
router.post('/', authenticate, requireRole(...MANAGER_ROLES), (req, res) => {
  const { courseId, title, content, durationMinutes, orderIndex } = req.body;
  if (!courseId || !title) return res.status(400).json({ message: 'courseId and title are required' });
  const course = store.courses.find((c) => c.id === courseId);
  if (!course) return res.status(404).json({ message: 'Course not found' });
  const newLesson = {
    id: uuidv4(),
    courseId,
    title,
    content: content || '',
    durationMinutes: durationMinutes || 15,
    orderIndex: orderIndex || (store.lessons.filter((l) => l.courseId === courseId).length + 1),
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };
  store.lessons.push(newLesson);
  // Update course lessons count
  const courseIdx = store.courses.findIndex((c) => c.id === courseId);
  if (courseIdx !== -1) store.courses[courseIdx].lessonsCount = store.lessons.filter((l) => l.courseId === courseId).length;
  res.status(201).json(newLesson);
});

// PUT /lessons/:id - Admin/Teacher
router.put('/:id', authenticate, requireRole(...MANAGER_ROLES), (req, res) => {
  const idx = store.lessons.findIndex((l) => l.id === req.params.id);
  if (idx === -1) return res.status(404).json({ message: 'Lesson not found' });
  ['title', 'content', 'durationMinutes', 'orderIndex'].forEach((f) => {
    if (req.body[f] !== undefined) store.lessons[idx][f] = req.body[f];
  });
  store.lessons[idx].updatedAt = new Date().toISOString();
  res.json(store.lessons[idx]);
});

// DELETE /lessons/:id - Admin/Teacher
router.delete('/:id', authenticate, requireRole(...MANAGER_ROLES), (req, res) => {
  const idx = store.lessons.findIndex((l) => l.id === req.params.id);
  if (idx === -1) return res.status(404).json({ message: 'Lesson not found' });
  const courseId = store.lessons[idx].courseId;
  store.lessons.splice(idx, 1);
  store.exercises = store.exercises.filter((e) => e.lessonId !== req.params.id);
  // Update course lessons count
  const courseIdx = store.courses.findIndex((c) => c.id === courseId);
  if (courseIdx !== -1) store.courses[courseIdx].lessonsCount = store.lessons.filter((l) => l.courseId === courseId).length;
  res.json({ message: 'Lesson deleted' });
});

module.exports = router;
