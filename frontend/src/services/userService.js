import api from './api';

/**
 * Chuẩn hóa user từ GET /users/me — hỗ trợ cả camelCase (Express/Jackson) và snake_case (giống cột DB).
 */
export function normalizeUserProfile(raw) {
  if (!raw || typeof raw !== 'object') return {};
  return {
    id: raw.id ?? '',
    firstName: raw.firstName ?? raw.first_name ?? '',
    lastName: raw.lastName ?? raw.last_name ?? '',
    email: raw.email ?? '',
    avatarUrl: raw.avatarUrl ?? raw.avatar_url ?? '',
    emailVerified: raw.emailVerified ?? raw.email_verified,
    isActive: raw.isActive ?? raw.is_active,
    createdAt: raw.createdAt ?? raw.created_at ?? null,
    updatedAt: raw.updatedAt ?? raw.updated_at ?? null,
    role: raw.role ?? '',
    phone: raw.phone ?? '',
    provider: raw.provider ?? '',
    providerId: raw.providerId ?? raw.provider_id ?? '',
    uiLanguage: raw.uiLanguage ?? raw.ui_language ?? '',
    nativeLanguage: raw.nativeLanguage ?? raw.native_language,
    onboardingCompleted: raw.onboardingCompleted ?? raw.onboarding_completed,
  };
}

export const getProfile = () => api.get('/users/me');

/**
 * PUT /users/me — chỉ gửi một bộ trường (camelCase).
 * Tránh gửi trùng first_name/firstName trong cùng body (một số API Spring trả 400).
 */
export const updateProfile = (data) => {
  const body = {
    firstName: data.firstName ?? '',
    lastName: data.lastName ?? '',
    avatarUrl: data.avatarUrl ?? '',
  };
  const phone = (data.phone ?? '').trim();
  const ui = (data.uiLanguage ?? '').trim();
  if (phone !== '') body.phone = phone;
  if (ui !== '') body.uiLanguage = ui;
  return api.put('/users/me', body);
};

/**
 * Đổi mật khẩu — gửi đủ camelCase + snake_case để khớp Express hoặc Spring.
 * Thử PUT → PATCH nếu 404/405; nếu 500/400 thử PATCH (một số server chỉ đăng ký PATCH).
 */
export async function changePassword(data) {
  const currentPassword = data.currentPassword;
  const newPassword = data.newPassword;
  const merged = {
    currentPassword,
    newPassword,
    current_password: currentPassword,
    new_password: newPassword,
  };

  const tryPut = () => api.put('/users/me/password', merged);
  const tryPatch = () => api.patch('/users/me/password', merged);

  try {
    return await tryPut();
  } catch (err) {
    const status = err.response?.status;
    if (status === 404 || status === 405) {
      return tryPatch();
    }
    if (status === 500 || status === 400) {
      try {
        return await tryPatch();
      } catch (err2) {
        const snakeOnly = {
          current_password: currentPassword,
          new_password: newPassword,
        };
        try {
          return await api.put('/users/me/password', snakeOnly);
        } catch {
          try {
            return await api.patch('/users/me/password', snakeOnly);
          } catch {
            throw err;
          }
        }
      }
    }
    throw err;
  }
}
