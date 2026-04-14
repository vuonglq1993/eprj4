import axios from 'axios';

const BASE_URL = (import.meta.env.VITE_API_BASE_URL) || '/api/v1';

const api = axios.create({
  baseURL: BASE_URL,
  headers: { 'Content-Type': 'application/json' },
});

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
    const raw = localStorage.getItem('auth_tokens');
    const t = raw ? JSON.parse(raw).accessToken : null;
    return typeof t === 'string' && t.trim().length > 0;
  } catch {
    return false;
  }
}

/**
 * GET danh mục có thể cho phép anonymous.
 * Chỉ bỏ Bearer khi **chưa đăng nhập** — nếu đã có JWT mà vẫn xóa header, Spring thường coi là
 * anonymous và trả 403 dù endpoint yêu cầu authenticated (Admin/User).
 *
 * GET /courses (progress theo user) — không nằm trong danh sách này.
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

api.interceptors.request.use((config) => {
  const url = config.url || '';
  if (isPublicAuthPath(url)) return config;
  if (isPublicResourceGet(config)) {
    delete config.headers.Authorization;
    return config;
  }

  const raw = localStorage.getItem('auth_tokens');
  if (raw) {
    try {
      const { accessToken } = JSON.parse(raw);
      if (accessToken) config.headers.Authorization = `Bearer ${accessToken}`;
    } catch {}
  }
  return config;
});

function clearSessionAndRedirectLogin() {
  localStorage.removeItem('auth_tokens');
  localStorage.removeItem('auth_user');
  if (!window.location.pathname.startsWith('/login')) {
    window.location.href = '/login';
  }
}

/**
 * Các GET chỉ cần đăng nhập (isAuthenticated). Backend gán mọi AccessDenied = 403 + message "admin"
 * trong khi thực tế thường là JWT hết hạn / không hợp lệ / không gửi Bearer → xử lý giống 401.
 */
function shouldTreat403AsAuthFailure(url) {
  if (!url) return false;
  const path = url.split('?')[0];
  return (
    path.includes('/payments/history') ||
    path.includes('/study-logs/streak') ||
    path.endsWith('/subscriptions/status') ||
    path.includes('/subscriptions/status')
  );
}

api.interceptors.response.use(
  (response) => response,
  (error) => {
    const status = error.response?.status;
    const reqUrl = error.config?.url || '';
    if (status === 401) {
      clearSessionAndRedirectLogin();
    }
    if (status === 403 && (reqUrl.includes('/users/me') || shouldTreat403AsAuthFailure(reqUrl))) {
      clearSessionAndRedirectLogin();
    }
    return Promise.reject(error);
  }
);

export default api;
