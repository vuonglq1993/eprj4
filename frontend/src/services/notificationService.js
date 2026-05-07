import api from './api';

// ── FCM Admin endpoints ──────────────────────────────────────

export const broadcastNotification = (data) =>
  api.post('/fcm/broadcast', data);

export const sendNotification = (userId, data) =>
  api.post('/fcm/send', { userId, ...data });

export const getBroadcastHistory = (limit = 20) =>
  api.get(`/fcm/broadcast/history?limit=${limit}`);

// ── User search (admin) ──────────────────────────────────────

export const searchUsers = (q) =>
  api.get(`/users/search?q=${encodeURIComponent(q)}`);
