import api from './api';

export const getCourses = (params = {}) => api.get('/courses', { params });

export const getCourse = (id) => api.get(`/courses/${id}`);

export const createCourse = (data) => api.post('/courses', data);

export const updateCourse = (id, data) => api.put(`/courses/${id}`, data);

export const publishCourse = (id) => api.patch(`/courses/${id}/publish`);

export const deleteCourse = (id) => api.delete(`/courses/${id}`);

export const getCourseTopics = (courseId) => api.get(`/courses/${courseId}/topics`);

export const addCourseTopic = (courseId, topicId) => api.post(`/courses/${courseId}/topics/${topicId}`);

export const removeCourseTopic = (courseId, topicId) => api.delete(`/courses/${courseId}/topics/${topicId}`);
