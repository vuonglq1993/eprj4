import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import AuthLayout from '../layouts/AuthLayout';

function Login() {
  const navigate = useNavigate();
  const { login } = useAuth();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    const result = await login(email, password);
    setLoading(false);
    if (result.success) {
      navigate('/', { replace: true });
    } else {
      setError(result.message || 'Đăng nhập thất bại.');
    }
  };

  return (
    <AuthLayout
      headline="LinguaNext"
      subline="Hệ thống quản trị"
      adminMode
    >
      <div className="auth-form">
        <h1 className="auth-form__title">Login</h1>
        <p className="auth-form__subtitle">
          How do i get started lorem ipsum dolor at?
        </p>

        <form className="auth-form__form" onSubmit={handleSubmit} noValidate>
          {error && (
            <div className="auth-form__error" role="alert">
              {error}
            </div>
          )}

          <div className="auth-form__field">
            <label className="auth-form__label" htmlFor="login-email">
              Email
            </label>
            <input
              id="login-email"
              type="email"
              className="auth-form__input"
              placeholder="Enter your email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              autoComplete="email"
            />
          </div>

          <div className="auth-form__field">
            <label className="auth-form__label" htmlFor="login-password">
              Password
            </label>
            <input
              id="login-password"
              type="password"
              className="auth-form__input"
              placeholder="••••••••"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              autoComplete="current-password"
            />
          </div>

          <button
            type="submit"
            className="auth-form__submit"
            disabled={loading}
          >
            {loading ? 'Signing in…' : 'Sign in'}
          </button>
        </form>
      </div>
    </AuthLayout>
  );
}

export default Login;
