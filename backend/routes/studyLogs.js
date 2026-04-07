const express = require('express');
const { v4: uuidv4 } = require('uuid');
const { authenticate } = require('../middleware/auth');
const store = require('../data/store');

const router = express.Router();

// GET /study-logs - Authenticated
router.get('/', authenticate, (req, res) => {
  const logs = store.studyLogs.filter((l) => l.userId === req.user.id);
  res.json(logs);
});

// GET /study-logs/streak - Authenticated
router.get('/streak', authenticate, (req, res) => {
  const logs = store.studyLogs
    .filter((l) => l.userId === req.user.id)
    .sort((a, b) => new Date(b.date) - new Date(a.date));
  let streak = 0;
  const today = new Date().toISOString().split('T')[0];
  let checkDate = new Date();
  for (const log of logs) {
    const logDate = log.date;
    const expected = checkDate.toISOString().split('T')[0];
    if (logDate === expected) {
      streak++;
      checkDate.setDate(checkDate.getDate() - 1);
    } else {
      break;
    }
  }
  res.json({ streak, logs });
});

// POST /study-logs - Authenticated
router.post('/', authenticate, (req, res) => {
  const { date, minutesSpent, lessonsCompleted } = req.body;
  const logDate = date || new Date().toISOString().split('T')[0];
  // Update existing log for this date or create new
  const existingIdx = store.studyLogs.findIndex(
    (l) => l.userId === req.user.id && l.date === logDate
  );
  if (existingIdx !== -1) {
    store.studyLogs[existingIdx].minutesSpent += minutesSpent || 0;
    store.studyLogs[existingIdx].lessonsCompleted += lessonsCompleted || 0;
    res.json(store.studyLogs[existingIdx]);
  } else {
    const newLog = {
      id: uuidv4(),
      userId: req.user.id,
      date: logDate,
      minutesSpent: minutesSpent || 0,
      lessonsCompleted: lessonsCompleted || 0,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };
    store.studyLogs.push(newLog);
    res.status(201).json(newLog);
  }
});

module.exports = router;
