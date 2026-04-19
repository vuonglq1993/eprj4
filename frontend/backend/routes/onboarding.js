const express = require('express');
const { v4: uuidv4 } = require('uuid');
const { authenticate } = require('../middleware/auth');
const store = require('../data/store');

const router = express.Router();

// GET /onboarding/status - Authenticated
router.get('/status', authenticate, (req, res) => {
  const user = store.users.find((u) => u.id === req.user.id);
  const data = store.onboardingData[req.user.id];
  res.json({
    onboardingCompleted: user?.onboardingCompleted || false,
    answers: data || {},
  });
});

// GET /onboarding/me - Authenticated
router.get('/me', authenticate, (req, res) => {
  const data = store.onboardingData[req.user.id];
  if (!data) return res.status(404).json({ message: 'Onboarding data not found' });
  res.json(data);
});

// POST /onboarding - Authenticated
router.post('/', authenticate, (req, res) => {
  const { nativeLanguage, learningLanguage, currentLevel, goal, dailyMinutes } = req.body;
  if (!nativeLanguage || !learningLanguage || !currentLevel || !goal || dailyMinutes == null) {
    return res.status(400).json({ message: 'All fields are required' });
  }
  const onboarding = {
    nativeLanguage,
    learningLanguage,
    currentLevel,
    goal,
    dailyMinutes: Number(dailyMinutes),
  };
  store.onboardingData[req.user.id] = onboarding;
  // Mark user as onboarding completed
  const userIdx = store.users.findIndex((u) => u.id === req.user.id);
  if (userIdx !== -1) {
    store.users[userIdx].onboardingCompleted = true;
  }
  // Suggest a learning path based on language + level
  const suggestedPath = store.learningPaths.find(
    (lp) =>
      lp.languageName?.toLowerCase().includes(learningLanguage.toLowerCase()) &&
      lp.targetLevel === currentLevel &&
      lp.isPublished
  ) || store.learningPaths.find((lp) => lp.isPublished) || null;

  res.status(201).json({
    message: 'Onboarding completed',
    suggestedPath: suggestedPath
      ? { id: suggestedPath.id, title: suggestedPath.title }
      : null,
    ...onboarding,
  });
});

module.exports = router;
