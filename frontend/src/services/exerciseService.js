import api from './api';

export const getExercises = (courseId, lessonId) =>
  api.get(`/courses/${courseId}/lessons/${lessonId}/exercises`);

export const createExercise = (courseId, lessonId, data) =>
  api.post(`/courses/${courseId}/lessons/${lessonId}/exercises`, data);

export const updateExercise = (courseId, lessonId, exerciseId, data) =>
  api.put(`/courses/${courseId}/lessons/${lessonId}/exercises/${exerciseId}`, data);

export const deleteExercise = (courseId, lessonId, exerciseId) =>
  api.delete(`/courses/${courseId}/lessons/${lessonId}/exercises/${exerciseId}`);

export const submitExercise = (data) =>
  api.post(`/courses/${data.courseId}/lessons/${data.lessonId}/exercises/submit`, {
    exerciseId: data.exerciseId,
    answer: data.answer,
  });
