import api from './api';

export const getOnboardingStatus = () => api.get('/onboarding/status');

export const submitOnboarding = (data) => api.post('/onboarding', data);

export const getMyOnboarding = () => api.get('/onboarding/me');
