/**
 * Role utilities.
 *
 * PREFER: useAuth() → user.role
 * USE THESE: chỉ khi component không thể access context trực tiếp
 */

/** Đọc role từ localStorage (cache login). Nên dùng useAuth().user.role khi có thể. */
function getStoredRole() {
  try {
    const raw = localStorage.getItem('auth_user');
    if (!raw) return null;
    const user = JSON.parse(raw);
    return user?.role || null;
  } catch {
    return null;
  }
}

export const isAdmin = () => getStoredRole() === 'admin';

export const hasRole = (...roles) => roles.includes(getStoredRole());
