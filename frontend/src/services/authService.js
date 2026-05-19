import api from './api';

export const login = (email, password) =>
  api.post('/auth/login', { email, password });

export const register = (data) =>
  api.post('/auth/register', data);

export const loginWithGoogle = (idToken) =>
  api.post('/auth/google', { idToken });

export const refreshTokens = (refreshToken) =>
  api.post('/auth/refresh', { refreshToken });

/** Logout: gửi refreshToken để backend blacklist cả 2 token. */
export const logout = async () => {
  try {
    const raw = localStorage.getItem('auth_tokens');
    const { refreshToken } = raw ? JSON.parse(raw) : {};
    await api.post('/auth/logout', refreshToken ? { refreshToken } : {});
  } catch {
    /* ignore */
  }
};
