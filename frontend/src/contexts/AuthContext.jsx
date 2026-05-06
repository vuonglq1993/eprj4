import { createContext, useContext, useState, useCallback, useEffect } from 'react';
import { useLocation } from 'react-router-dom';
import { login as apiLogin, logout as apiLogout } from '../services/authService';
import { getProfile, normalizeUserProfile } from '../services/userService';

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

function hasUsableAccessToken() {
  const t = getStoredTokens()?.accessToken;
  return typeof t === 'string' && t.trim().length > 0;
}

function profileToUser(p) {
  const n = normalizeUserProfile(p);
  return {
    id: n.id,
    email: n.email,
    firstName: n.firstName,
    lastName: n.lastName,
    avatarUrl: n.avatarUrl,
    role: (n.role || '').toLowerCase(),
  };
}

function clearSession() {
  localStorage.removeItem(TOKENS_KEY);
  localStorage.removeItem(USER_KEY);
}

export function AuthProvider({ children }) {
  const [user, setUser] = useState(getStoredUser);
  const [isAuth, setIsAuth] = useState(hasUsableAccessToken);
  const [loading, setLoading] = useState(false);
  const location = useLocation();

  // Sync isAuth whenever user state changes
  useEffect(() => {
    setIsAuth(hasUsableAccessToken());
  }, [user]);

  // Re-fetch profile whenever route changes — keeps role in sync with DB
  useEffect(() => {
    if (!hasUsableAccessToken()) return;

    let cancelled = false;
    setLoading(true);

    getProfile()
      .then((res) => {
        if (cancelled || !res.data) return;
        const next = profileToUser(res.data);
        setUser(next);
        localStorage.setItem(USER_KEY, JSON.stringify(next));
      })
      .catch((err) => {
        if (cancelled) return;
        const status = err.response?.status;
        if (status === 401 || status === 403) {
          setUser(null);
          setIsAuth(false);
          clearSession();
        }
      })
      .finally(() => {
        if (!cancelled) setLoading(false);
      });

    return () => {
      cancelled = true;
      setLoading(false);
    };
  }, [location.pathname]);

  // Poll profile every 10s so role changes take effect without navigation
  useEffect(() => {
    if (!hasUsableAccessToken()) return;

    const interval = setInterval(() => {
      getProfile()
        .then((res) => {
          if (!res.data) return;
          const next = profileToUser(res.data);
          setUser(next);
          localStorage.setItem(USER_KEY, JSON.stringify(next));
        })
        .catch(() => {});
    }, 10000);

    return () => clearInterval(interval);
  }, []);

  // Listen for forced logout events from api interceptor
  useEffect(() => {
    const handleForceLogout = () => {
      setUser(null);
      setIsAuth(false);
      clearSession();
    };
    window.addEventListener('auth:logout', handleForceLogout);
    return () => window.removeEventListener('auth:logout', handleForceLogout);
  }, []);

  const login = useCallback(async (email, password) => {
    try {
      const res = await apiLogin(email, password);
      const { accessToken, refreshToken, user: userData } = res.data;

      const role = (userData.role || '').toLowerCase().trim();
      if (role !== 'admin') {
        return { success: false, message: 'Bạn không có quyền đăng nhập.' };
      }

      const tokens = { accessToken, refreshToken };
      const toStore = {
        id: userData.id,
        email: userData.email,
        firstName: userData.firstName,
        lastName: userData.lastName,
        avatarUrl: userData.avatarUrl,
        role,
      };
      setUser(toStore);
      setIsAuth(true);
      setLoading(false);
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
    setIsAuth(false);
    setLoading(false);
    localStorage.removeItem(TOKENS_KEY);
    localStorage.removeItem(USER_KEY);
  }, []);

  return (
    <AuthContext.Provider
      value={{
        user,
        login,
        logout,
        isAuthenticated: isAuth,
        authLoading: loading,
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
