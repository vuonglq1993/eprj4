import api from './api';

export const logStudy = (data) => api.post('/study-logs', data);

export const getStreak = () => api.get('/study-logs/streak');
