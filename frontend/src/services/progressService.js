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

const getLeaderboardData = () => api.get('/game/leaderboard').then((r) => {
  const arr = r?.data?.weekly ?? r?.data?.content ?? r?.data ?? [];
  return Array.isArray(arr) ? arr.length : 0;
}).catch(() => 0);

export const getDashboard = async () => {
  const results = await Promise.allSettled([
    getUsersCount(),
    getCoursesCount(),
    getStreakData(),
    getRevenueData(),
    getLeaderboardData(),
  ]).catch(() => []);

  const get = (idx, fallback = 0) =>
    results[idx]?.status === 'fulfilled' ? results[idx].value : fallback

  const s = get(0)
  const c = get(1)
  const st = get(2, null)
  const rv = get(3)
  const al = get(4)

  return {
    data: {
      totalUsers: s,
      totalCourses: c,
      activeUsers: al,
      activeSessions: al,
      totalRevenue: rv,
      streakDays: st?.currentStreak ?? st?.streak ?? 0,
    },
  };
};

export const getAdminDailyActive = (days = 7) =>
  api.get('/admin/stats/daily-active', { params: { days } }).then((r) => r.data).catch(() => null);

export const getAdminSubscriptionBreakdown = () =>
  api.get('/admin/stats/subscription-breakdown').then((r) => r.data).catch(() => null);

export const getTopLeaderboard = (limit = 5) =>
  api.get('/game/leaderboard', { params: { type: 'weekly' } }).then((r) => {
    const arr = r?.data?.weekly ?? r?.data?.content ?? r?.data?.data ?? [];
    return arr.slice(0, limit);
  }).catch(() => []);

export const getCourseProgress = (courseId) =>
  api.get(`/progress/courses/${courseId}`);

export const getProgressStats = (period = 'WEEK') =>
  api.get('/progress/stats', { params: { period } });

export const getCertificate = (courseId) =>
  api.get(`/progress/courses/${courseId}/certificate`);
