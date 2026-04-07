const express = require('express');
const cors = require('cors');

const authRoutes = require('./routes/auth');
const languagesRoutes = require('./routes/languages');
const learningPathsRoutes = require('./routes/learningPaths');
const topicsRoutes = require('./routes/topics');
const onboardingRoutes = require('./routes/onboarding');
const subscriptionPlansRoutes = require('./routes/subscriptionPlans');
const coursesRoutes = require('./routes/courses');
const lessonsRoutes = require('./routes/lessons');
const exercisesRoutes = require('./routes/exercises');
const usersRoutes = require('./routes/users');
const subscriptionsRoutes = require('./routes/subscriptions');
const paymentsRoutes = require('./routes/payments');
const studyLogsRoutes = require('./routes/studyLogs');
const progressRoutes = require('./routes/progress');
const dashboardRoutes = require('./routes/dashboard');

const app = express();
const PORT = process.env.PORT || 8080;

app.use(cors());
app.use(express.json());

// Health check
app.get('/api/v1/health', (req, res) => {
  res.json({ status: 'ok', message: 'EPRJ4 Backend API is running' });
});

// Routes
app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/languages', languagesRoutes);
app.use('/api/v1/learning-paths', learningPathsRoutes);
app.use('/api/v1/topics', topicsRoutes);
app.use('/api/v1/onboarding', onboardingRoutes);
app.use('/api/v1/subscription-plans', subscriptionPlansRoutes);
app.use('/api/v1/courses', coursesRoutes);
app.use('/api/v1/lessons', lessonsRoutes);
app.use('/api/v1/exercises', exercisesRoutes);
app.use('/api/v1/users', usersRoutes);
app.use('/api/v1/subscriptions', subscriptionsRoutes);
app.use('/api/v1/payments', paymentsRoutes);
app.use('/api/v1/study-logs', studyLogsRoutes);
app.use('/api/v1/progress', progressRoutes);
app.use('/api/v1/dashboard', dashboardRoutes);

// 404 handler
app.use((req, res) => {
  res.status(404).json({ message: `Route ${req.method} ${req.path} not found` });
});

// Error handler
app.use((err, req, res, next) => {
  console.error('Error:', err.message);
  res.status(500).json({ message: 'Internal server error' });
});

app.listen(PORT, () => {
  console.log(`EPRJ4 Backend API running on http://localhost:${PORT}/api/v1`);
});
