import api from './api';

export const getLessons = (courseId) =>
  api.get(`/courses/${courseId}/lessons`);

export const getLesson = (courseId, lessonId) =>
  api.get(`/courses/${courseId}/lessons/${lessonId}`);

export const createLesson = (courseId, data) =>
  api.post(`/courses/${courseId}/lessons`, data);

export const updateLesson = (courseId, lessonId, data) =>
  api.put(`/courses/${courseId}/lessons/${lessonId}`, data);

export const deleteLesson = (courseId, lessonId) =>
  api.delete(`/courses/${courseId}/lessons/${lessonId}`);
