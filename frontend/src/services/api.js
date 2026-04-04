import axios from 'axios';

const BASE_URL = '/api/v1';

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

/**
 * GET /languages không dùng principal — luôn public; token lỗi/expired đôi khi gây 403 nên không gửi Bearer.
 * GET /courses có @AuthenticationPrincipal (progress) — vẫn gửi token khi có.
 */
function isPublicResourceGet(config) {
  const method = (config.method || 'get').toLowerCase();
  if (method !== 'get') return false;
  const path = (config.url || '').split('?')[0];
  return path === '/languages' || path.startsWith('/languages/');
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
