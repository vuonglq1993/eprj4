import api from './api';

export const getPaymentHistory = () => api.get('/payments/history');

export const getStudyStreak = () => api.get('/study-logs/streak');
