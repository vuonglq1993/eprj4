const express = require('express');
const { authenticate } = require('../middleware/auth');
const store = require('../data/store');

const router = express.Router();

// GET /dashboard - Authenticated
router.get('/', authenticate, (req, res) => {
  const userId = req.user.id;
  const role = req.user.role;

  const userProgress = store.progress.filter((p) => p.userId === userId);
  const totalMinutes = store.studyLogs
    .filter((l) => l.userId === userId)
    .reduce((sum, l) => sum + (l.minutesSpent || 0), 0);
  const totalLessons = userProgress.reduce((sum, p) => sum + (p.completedLessons || 0), 0);
  const activeSubscription = store.subscriptions.find(
    (s) => s.userId === userId && s.status === 'ACTIVE'
  );
  const enrolledPaths = store.enrollments.filter((e) => e.userId === userId);
  const streak = (() => {
    const logs = store.studyLogs
      .filter((l) => l.userId === userId)
      .sort((a, b) => new Date(b.date) - new Date(a.date));
    let s = 0;
    let checkDate = new Date();
    for (const log of logs) {
      if (log.date === checkDate.toISOString().split('T')[0]) {
        s++;
        checkDate.setDate(checkDate.getDate() - 1);
      } else break;
    }
    return s;
  })();

  if (role === 'ADMIN') {
    res.json({
      totalUsers: store.users.length,
      totalCourses: store.courses.length,
      totalPaths: store.learningPaths.length,
      totalSubscriptions: store.subscriptions.length,
      totalRevenue: store.payments.reduce((sum, p) => sum + (p.amount || 0), 0),
    });
  } else {
    res.json({
      coursesInProgress: userProgress.length,
      totalLessonsCompleted: totalLessons,
      totalMinutesStudied: totalMinutes,
      streak,
      enrolledPaths: enrolledPaths.length,
      hasActiveSubscription: !!activeSubscription,
      activePlan: activeSubscription
        ? (store.subscriptionPlans.find((p) => p.id === activeSubscription.planId) || null)
        : null,
    });
  }
});

module.exports = router;
