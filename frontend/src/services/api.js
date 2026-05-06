import axios from 'axios';

const BASE_URL = (import.meta.env.VITE_API_BASE_URL) || '/api/v1';

const api = axios.create({
  baseURL: BASE_URL,
  headers: { 'Content-Type': 'application/json' },
});

const TOKENS_KEY = 'auth_tokens';

function isPublicAuthPath(url) {
  const path = (url || '').split('?')[0];
  return (
    path.includes('/auth/login') ||
    path.includes('/auth/register') ||
    path.includes('/auth/google')
  );
}

function hasStoredAccessToken() {
  try {
    const raw = localStorage.getItem(TOKENS_KEY);
    const t = raw ? JSON.parse(raw).accessToken : null;
    return typeof t === 'string' && t.trim().length > 0;
  } catch {
    return false;
  }
}

/**
 * GET danh mục công khai — chỉ bỏ Bearer khi chưa đăng nhập.
 */
function isPublicCatalogGetPath(path) {
  if (path === '/languages' || path.startsWith('/languages/')) return true;
  if (path === '/learning-paths') return true;
  const lpSeg = path.match(/^\/learning-paths\/([^/]+)$/);
  if (lpSeg && lpSeg[1] !== 'my') return true;
  if (path === '/topics' || path.startsWith('/topics/')) return true;
  if (path === '/subscription-plans') return true;
  if (/^\/subscription-plans\/[^/]+$/.test(path)) return true;
  return false;
}

function isPublicResourceGet(config) {
  const method = (config.method || 'get').toLowerCase();
  if (method !== 'get') return false;
  const path = (config.url || '').split('?')[0];
  if (!isPublicCatalogGetPath(path)) return false;
  if (hasStoredAccessToken()) return false;
  return true;
}

// ── Request interceptor ───────────────────────────────────────
api.interceptors.request.use((config) => {
  const url = config.url || '';
  if (isPublicAuthPath(url)) return config;
  if (isPublicResourceGet(config)) {
    delete config.headers.Authorization;
    return config;
  }

  const raw = localStorage.getItem(TOKENS_KEY);
  if (raw) {
    try {
      const { accessToken } = JSON.parse(raw);
      if (accessToken) config.headers.Authorization = `Bearer ${accessToken}`;
    } catch {}
  }
  return config;
});

// ── Refresh token helpers ─────────────────────────────────────
let isRefreshing = false;
let refreshSubscribers = [];

function subscribeTokenRefresh(cb) {
  refreshSubscribers.push(cb);
}

function onTokenRefreshed(token) {
  refreshSubscribers.forEach((cb) => cb(token));
  refreshSubscribers = [];
}

function clearSession() {
  localStorage.removeItem(TOKENS_KEY);
  localStorage.removeItem('auth_user');
}

function redirectToLogin() {
  if (!window.location.pathname.startsWith('/login')) {
    window.location.href = '/login';
  }
}

// ── Response interceptor ──────────────────────────────────────
api.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;
    const status = error.response?.status;
    const reqUrl = originalRequest?.url || '';

    // 401 — token hết hạn hoặc không hợp lệ → thử refresh
    if (status === 401 && originalRequest && !originalRequest._retry) {
      // Không refresh cho auth endpoints
      if (isPublicAuthPath(reqUrl)) {
        return Promise.reject(error);
      }

      originalRequest._retry = true;

      if (!isRefreshing) {
        isRefreshing = true;

        try {
          const raw = localStorage.getItem(TOKENS_KEY);
          const { refreshToken } = JSON.parse(raw || '{}');

          if (!refreshToken) throw new Error('No refresh token');

          // Gọi endpoint refresh (backend chưa có → tạm thời fallback)
          // Khi backend có /auth/refresh, uncomment dòng dưới và xóa catch
          // const res = await axios.post(`${BASE_URL}/auth/refresh`, {}, {
          //   headers: { Authorization: `Bearer ${refreshToken}` }
          // });
          // const { accessToken, refreshToken: newRt } = res.data;
          // const newTokens = { accessToken, refreshToken: newRt || refreshToken };
          // localStorage.setItem(TOKENS_KEY, JSON.stringify(newTokens));
          // onTokenRefreshed(accessToken);

          // Tạm thời: nếu không refresh được, xóa session
          throw new Error('Refresh not available');
        } catch {
          isRefreshing = false;
          clearSession();
          redirectToLogin();
          return Promise.reject(error);
        }
      }

      // Đợi token mới rồi retry request gốc
      return new Promise((resolve) => {
        subscribeTokenRefresh((token) => {
          originalRequest.headers.Authorization = `Bearer ${token}`;
          resolve(api(originalRequest));
        });
      });
    }

    // 403 chỉ logout khi chắc chắn là auth failure (/users/me + subscription status)
    if (status === 403) {
      const isAuthCheck =
        reqUrl.includes('/users/me') ||
        reqUrl.includes('/subscriptions/status');

      if (isAuthCheck) {
        clearSession();
        redirectToLogin();
      }
    }

    return Promise.reject(error);
  }
);

export default api;
