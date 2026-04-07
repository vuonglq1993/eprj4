import api from './api';

export const getLearningPaths = (params = {}) =>
  api.get('/learning-paths', { params });

export const getLearningPath = (id) =>
  api.get(`/learning-paths/${id}`);

export const enrollInPath = (id) =>
  api.post(`/learning-paths/${id}/enroll`);

export const unenrollFromPath = (id) =>
  api.delete(`/learning-paths/${id}/enroll`);

export const getMyPaths = () =>
  api.get('/learning-paths/my');

export const createLearningPath = (data) =>
  api.post('/learning-paths', data);

export const updateLearningPath = (id, data) =>
  api.put(`/learning-paths/${id}`, data);

export const togglePublishLearningPath = (id) =>
  api.patch(`/learning-paths/${id}/publish`);

export const deleteLearningPath = (id) =>
  api.delete(`/learning-paths/${id}`);
