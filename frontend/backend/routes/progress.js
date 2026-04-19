const express = require('express');
const { v4: uuidv4 } = require('uuid');
const { authenticate } = require('../middleware/auth');
const store = require('../data/store');

const router = express.Router();

// GET /progress/courses/:courseId - Authenticated
router.get('/courses/:courseId', authenticate, (req, res) => {
  const prog = store.progress.find(
    (p) => p.userId === req.user.id && p.courseId === req.params.courseId
  );
  if (!prog) return res.status(404).json({ message: 'Progress not found' });
  res.json(prog);
});

// GET /progress/stats - Authenticated
router.get('/stats', authenticate, (req, res) => {
  const userProgress = store.progress.filter((p) => p.userId === req.user.id);
  const totalMinutes = store.studyLogs
    .filter((l) => l.userId === req.user.id)
    .reduce((sum, l) => sum + (l.minutesSpent || 0), 0);
  const totalLessons = userProgress.reduce((sum, p) => sum + (p.completedLessons || 0), 0);
  const totalCourses = userProgress.length;
  const avgPercent = totalCourses > 0
    ? Math.round(userProgress.reduce((sum, p) => sum + (p.percentComplete || 0), 0) / totalCourses)
    : 0;
  res.json({
    totalCourses,
    totalLessonsCompleted: totalLessons,
    totalMinutesStudied: totalMinutes,
    averageProgress: avgPercent,
  });
});

// POST /progress/courses/:courseId - Authenticated
router.post('/courses/:courseId', authenticate, (req, res) => {
  const course = store.courses.find((c) => c.id === req.params.courseId);
  if (!course) return res.status(404).json({ message: 'Course not found' });
  const idx = store.progress.findIndex(
    (p) => p.userId === req.user.id && p.courseId === req.params.courseId
  );
  const { completedLessons, percentComplete } = req.body;
  if (idx !== -1) {
    store.progress[idx].completedLessons = completedLessons ?? store.progress[idx].completedLessons;
    store.progress[idx].percentComplete = percentComplete ?? store.progress[idx].percentComplete;
    store.progress[idx].lastAccessedAt = new Date().toISOString();
    res.json(store.progress[idx]);
  } else {
    const newProg = {
      id: uuidv4(),
      userId: req.user.id,
      courseId: req.params.courseId,
      completedLessons: completedLessons || 0,
      totalLessons: course.lessonsCount || 0,
      percentComplete: percentComplete || 0,
      lastAccessedAt: new Date().toISOString(),
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };
    store.progress.push(newProg);
    res.status(201).json(newProg);
  }
});

// GET /progress/courses/:courseId/certificate - Authenticated
router.get('/courses/:courseId/certificate', authenticate, (req, res) => {
  const prog = store.progress.find(
    (p) => p.userId === req.user.id && p.courseId === req.params.courseId
  );
  if (!prog || prog.percentComplete < 100) {
    return res.status(400).json({ message: 'Certificate not available yet' });
  }
  const course = store.courses.find((c) => c.id === req.params.courseId);
  res.json({
    certificateId: `CERT_${prog.id.split('-')[0].toUpperCase()}`,
    courseName: course?.title || 'Unknown Course',
    userId: req.user.id,
    issuedAt: new Date().toISOString(),
    percentComplete: 100,
  });
});

module.exports = router;
