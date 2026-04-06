import api from './api';

export const getLanguages = () => api.get('/languages');

export const getLanguage = (id) => api.get(`/languages/${id}`);

export const createLanguage = (data) => api.post('/languages', data);

export const updateLanguage = (id, data) => api.put(`/languages/${id}`, data);

export const deleteLanguage = (id) => api.delete(`/languages/${id}`);
