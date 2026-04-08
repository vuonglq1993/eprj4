import api from './api';

export const getDashboard = () => api.get('/dashboard');

export const getCourseProgress = (courseId) =>
  api.get(`/progress/courses/${courseId}`);

export const getProgressStats = (period = 'WEEK') =>
  api.get('/progress/stats', { params: { period } });

export const getCertificate = (courseId) =>
  api.get(`/progress/courses/${courseId}/certificate`);
