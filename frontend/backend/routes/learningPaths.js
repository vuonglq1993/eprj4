const express = require('express');
const { v4: uuidv4 } = require('uuid');
const { authenticate, requireRole } = require('../middleware/auth');
const store = require('../data/store');

const router = express.Router();

const MANAGER_ROLES = ['ADMIN'];

// GET /learning-paths - Public
router.get('/', (req, res) => {
  const { languageId, targetLevel, isPublished } = req.query;
  let results = [...store.learningPaths];
  if (languageId) results = results.filter((p) => p.languageId === languageId);
  if (targetLevel) results = results.filter((p) => p.targetLevel === targetLevel);
  if (isPublished !== undefined) {
    const pub = isPublished === 'true';
    results = results.filter((p) => p.isPublished === pub);
  }
  res.json({ content: results });
});

// GET /learning-paths/my - Authenticated
router.get('/my', authenticate, (req, res) => {
  const enrolledPaths = store.learningPaths.filter((lp) =>
    store.enrollments.some((e) => e.learningPathId === lp.id && e.userId === req.user.id)
  );
  res.json(enrolledPaths);
});

// GET /learning-paths/:id
router.get('/:id', (req, res) => {
  const path = store.learningPaths.find((p) => p.id === req.params.id);
  if (!path) return res.status(404).json({ message: 'Learning path not found' });
  res.json(path);
});

// POST /learning-paths - Admin/Teacher
router.post('/', authenticate, requireRole(...MANAGER_ROLES), (req, res) => {
  const { title, description, languageId, targetLevel, thumbnailUrl, isPublished } = req.body;
  if (!title) return res.status(400).json({ message: 'Title is required' });
  const lang = store.languages.find((l) => l.id === languageId);
  const newPath = {
    id: uuidv4(),
    title,
    description: description || '',
    languageId: languageId || null,
    languageName: lang ? lang.name : null,
    targetLevel: targetLevel || 'BEGINNER',
    thumbnailUrl: thumbnailUrl || null,
    isPublished: isPublished || false,
    totalCourses: 0,
    creatorId: req.user.id,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };
  store.learningPaths.push(newPath);
  res.status(201).json(newPath);
});

// PUT /learning-paths/:id - Admin/Teacher
router.put('/:id', authenticate, requireRole(...MANAGER_ROLES), (req, res) => {
  const idx = store.learningPaths.findIndex((p) => p.id === req.params.id);
  if (idx === -1) return res.status(404).json({ message: 'Learning path not found' });
  const { title, description, languageId, targetLevel, thumbnailUrl, isPublished } = req.body;
  const lang = store.languages.find((l) => l.id === (languageId || store.learningPaths[idx].languageId));
  store.learningPaths[idx] = {
    ...store.learningPaths[idx],
    title: title !== undefined ? title : store.learningPaths[idx].title,
    description: description !== undefined ? description : store.learningPaths[idx].description,
    languageId: languageId !== undefined ? languageId : store.learningPaths[idx].languageId,
    languageName: lang ? lang.name : (store.learningPaths[idx].languageName || null),
    targetLevel: targetLevel !== undefined ? targetLevel : store.learningPaths[idx].targetLevel,
    thumbnailUrl: thumbnailUrl !== undefined ? thumbnailUrl : store.learningPaths[idx].thumbnailUrl,
    isPublished: isPublished !== undefined ? isPublished : store.learningPaths[idx].isPublished,
    updatedAt: new Date().toISOString(),
  };
  res.json(store.learningPaths[idx]);
});

// PATCH /learning-paths/:id/publish - Admin/Teacher
router.patch('/:id/publish', authenticate, requireRole(...MANAGER_ROLES), (req, res) => {
  const idx = store.learningPaths.findIndex((p) => p.id === req.params.id);
  if (idx === -1) return res.status(404).json({ message: 'Learning path not found' });
  store.learningPaths[idx].isPublished = !store.learningPaths[idx].isPublished;
  store.learningPaths[idx].updatedAt = new Date().toISOString();
  res.json(store.learningPaths[idx]);
});

// DELETE /learning-paths/:id - Admin/Teacher
router.delete('/:id', authenticate, requireRole(...MANAGER_ROLES), (req, res) => {
  const idx = store.learningPaths.findIndex((p) => p.id === req.params.id);
  if (idx === -1) return res.status(404).json({ message: 'Learning path not found' });
  store.learningPaths.splice(idx, 1);
  // Remove enrollments for this path
  store.enrollments = store.enrollments.filter((e) => e.learningPathId !== req.params.id);
  res.json({ message: 'Learning path deleted' });
});

// POST /learning-paths/:id/enroll - Authenticated
router.post('/:id/enroll', authenticate, (req, res) => {
  const path = store.learningPaths.find((p) => p.id === req.params.id);
  if (!path) return res.status(404).json({ message: 'Learning path not found' });
  const existing = store.enrollments.find(
    (e) => e.learningPathId === req.params.id && e.userId === req.user.id
  );
  if (existing) return res.status(409).json({ message: 'Already enrolled' });
  const enrollment = {
    id: uuidv4(),
    userId: req.user.id,
    learningPathId: req.params.id,
    enrolledAt: new Date().toISOString(),
  };
  store.enrollments.push(enrollment);
  res.status(201).json({ message: 'Enrolled successfully', ...enrollment });
});

// DELETE /learning-paths/:id/enroll - Authenticated
router.delete('/:id/enroll', authenticate, (req, res) => {
  const idx = store.enrollments.findIndex(
    (e) => e.learningPathId === req.params.id && e.userId === req.user.id
  );
  if (idx === -1) return res.status(404).json({ message: 'Not enrolled' });
  store.enrollments.splice(idx, 1);
  res.json({ message: 'Unenrolled successfully' });
});

module.exports = router;
