export const isAdmin = () => {
  try {
    const raw = localStorage.getItem('auth_user');
    if (!raw) return false;
    const user = JSON.parse(raw);
    return user?.role === 'ADMIN';
  } catch {
    return false;
  }
};

export const hasRole = (...roles) => {
  try {
    const raw = localStorage.getItem('auth_user');
    if (!raw) return false;
    const user = JSON.parse(raw);
    return roles.includes(user?.role);
  } catch {
    return false;
  }
};
