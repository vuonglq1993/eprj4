import { createContext, useContext, useState, useCallback, useEffect } from 'react';
import { login as apiLogin, logout as apiLogout } from '../services/authService';
import { getProfile } from '../services/userService';

const AuthContext = createContext(null);

const TOKENS_KEY = 'auth_tokens';
const USER_KEY = 'auth_user';

function getStoredUser() {
  try {
    const raw = localStorage.getItem(USER_KEY);
    return raw ? JSON.parse(raw) : null;
  } catch {
    return null;
  }
}

function getStoredTokens() {
  try {
    const raw = localStorage.getItem(TOKENS_KEY);
    return raw ? JSON.parse(raw) : null;
  } catch {
    return null;
  }
}

/** Có accessToken thật (không rỗng) — tránh coi {} hoặc token trống là đã đăng nhập rồi gọi API không Bearer → 403. */
function hasUsableAccessToken() {
  const t = getStoredTokens()?.accessToken;
  return typeof t === 'string' && t.trim().length > 0;
}

function profileToUser(p) {
  return {
    id: p.id,
    email: p.email,
    firstName: p.firstName,
    lastName: p.lastName,
    avatarUrl: p.avatarUrl,
    role: p.role,
  };
}

export function AuthProvider({ children }) {
  const [user, setUser] = useState(getStoredUser);

  useEffect(() => {
    if (!hasUsableAccessToken()) return;
    let cancelled = false;
    getProfile()
      .then((res) => {
        if (cancelled || !res.data) return;
        const next = profileToUser(res.data);
        setUser(next);
        localStorage.setItem(USER_KEY, JSON.stringify(next));
      })
      .catch(() => {});
    return () => {
      cancelled = true;
    };
  }, []);

  const login = useCallback(async (email, password) => {
    try {
      const res = await apiLogin(email, password);
      const { accessToken, refreshToken, user: userData } = res.data;
      const tokens = { accessToken, refreshToken };
      const toStore = userData;
      setUser(toStore);
      localStorage.setItem(TOKENS_KEY, JSON.stringify(tokens));
      localStorage.setItem(USER_KEY, JSON.stringify(toStore));
      return { success: true };
    } catch (err) {
      const msg = err.response?.data?.message || 'Email hoặc mật khẩu không đúng.';
      return { success: false, message: msg };
    }
  }, []);

  const logout = useCallback(async () => {
    try {
      await apiLogout();
    } catch {}
    setUser(null);
    localStorage.removeItem(TOKENS_KEY);
    localStorage.removeItem(USER_KEY);
  }, []);

  return (
    <AuthContext.Provider
      value={{
        user,
        login,
        logout,
        isAuthenticated: hasUsableAccessToken(),
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth must be used within AuthProvider');
  return ctx;
}
