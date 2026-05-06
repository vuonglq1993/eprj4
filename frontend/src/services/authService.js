import api from './api';

export const login = (email, password) =>
  api.post('/auth/login', { email, password });

export const register = (data) =>
  api.post('/auth/register', data);

export const loginWithGoogle = (idToken) =>
  api.post('/auth/google', { idToken });

export const refreshTokens = (refreshToken) =>
  api.post('/auth/refresh', {}, {
    headers: { Authorization: `Bearer ${refreshToken}` },
  });

/** Logout chủ yếu xóa session phía client; gọi API là tuỳ chọn. */
export const logout = async () => {
  try {
    await api.post('/auth/logout');
  } catch {
    /* ignore */
  }
};
