import api from './api';

export const getSubscriptionStatus = () => api.get('/subscriptions/status');

export const cancelSubscription = () => api.post('/subscriptions/cancel');
