import api from './api';

export const createPayment = (data) => api.post('/payments/create', data);

export const getPaymentHistory = () => api.get('/payments/history');
