import api from './api';
import { getUsersCount } from './userService';

const getCoursesCount = () => api.get('/courses', { params: { size: 1 } }).then((r) => {
  const total = r?.data?.totalElements ?? r?.data?.total ?? 0;
  return Number(total);
}).catch(() => 0);

const getStreakData = () => api.get('/study-logs/streak')
  .then((r) => r?.data ?? null)
  .catch(() => null);

const getRevenueData = () => api.get('/payments/history').then((r) => {
  const arr = r?.data?.content ?? r?.data?.data ?? r?.data ?? [];
  const total = arr.reduce((sum, p) => sum + (Number(p.amount) || 0), 0);
  return total;
}).catch(() => 0);

const getLeaderboardData = () => api.get('/game/leaderboard', { params: { type: 'weekly' } }).then((r) => {
  const arr = r?.data?.content ?? r?.data?.data ?? r?.data ?? [];
  return arr.length;
}).catch(() => 0);

export const getDashboard = async () => {
  const [usersCount, coursesCount, streak, revenue, activeSessions] = await Promise.all([
    getUsersCount(),
    getCoursesCount(),
    getStreakData(),
    getRevenueData(),
    getLeaderboardData(),
  ]);

  return {
    data: {
      totalUsers: usersCount,
      totalCourses: coursesCount,
      activeUsers: activeSessions,
      activeSessions,
      totalRevenue: revenue,
      streakDays: streak?.currentStreak ?? streak?.streak ?? 0,
    },
  };
};

export const getAdminDailyActive = (days = 7) =>
  api.get('/admin/stats/daily-active', { params: { days } }).then((r) => r.data).catch(() => null);

export const getAdminSubscriptionBreakdown = () =>
  api.get('/admin/stats/subscription-breakdown').then((r) => r.data).catch(() => null);

export const getTopLeaderboard = (limit = 5) =>
  api.get('/game/leaderboard', { params: { type: 'weekly' } }).then((r) => {
    const arr = r?.data?.content ?? r?.data?.data ?? r?.data ?? [];
    return arr.slice(0, limit);
  }).catch(() => []);

export const getCourseProgress = (courseId) =>
  api.get(`/progress/courses/${courseId}`);

export const getProgressStats = (period = 'WEEK') =>
  api.get('/progress/stats', { params: { period } });

export const getCertificate = (courseId) =>
  api.get(`/progress/courses/${courseId}/certificate`);
