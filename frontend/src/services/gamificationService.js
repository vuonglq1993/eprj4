import api from './api';

export const getGameProfile = () => api.get('/game/profile');

export const getLeaderboard = (type = 'weekly') =>
  api.get('/game/leaderboard', { params: { type } });

export const getWeeklyReport = () => api.get('/reports/weekly');

export const getMistakes = (page = 0, size = 20) =>
  api.get('/review/mistakes', { params: { page, size } });
