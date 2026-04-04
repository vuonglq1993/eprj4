import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import AuthLayout from '../layouts/AuthLayout';
import { FiEye, FiEyeOff } from 'react-icons/fi';
import { register } from '../services/authService';

function SignUp() {
  const navigate = useNavigate();
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [email, setEmail] = useState('');
  const [phone, setPhone] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    if (!firstName.trim() || !email.trim() || !phone.trim() || !password) {
      setError('Vui lòng điền đầy đủ thông tin.');
      return;
    }

    if (password.length < 8) {
      setError('Mật khẩu phải có ít nhất 8 ký tự.');
      return;
    }

    setLoading(true);
    try {
      await register({ firstName, lastName, email, phone, password });
      navigate('/login', { replace: true });
    } catch (err) {
      setError(err.response?.data?.message || 'Đăng ký thất bại. Vui lòng thử lại.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <AuthLayout
      headline="Very good works are waiting for you"
      subline="Sign up Now"
    >
      <div className="auth-form">
        <h1 className="auth-form__title">Sign up</h1>
        <p className="auth-form__subtitle">
          Start your 30-day free trial.
        </p>

        <form className="auth-form__form" onSubmit={handleSubmit} noValidate>
          {error && (
            <div className="auth-form__error" role="alert">
              {error}
            </div>
          )}

          <div className="auth-form__field">
            <input
              type="text"
              className="auth-form__input"
              placeholder="First Name *"
              value={firstName}
              onChange={(e) => setFirstName(e.target.value)}
              autoComplete="given-name"
            />
          </div>

          <div className="auth-form__field">
            <input
              type="text"
              className="auth-form__input"
              placeholder="Last Name"
              value={lastName}
              onChange={(e) => setLastName(e.target.value)}
              autoComplete="family-name"
            />
          </div>

          <div className="auth-form__field">
            <input
              type="email"
              className="auth-form__input"
              placeholder="Email Address *"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              autoComplete="email"
            />
          </div>

          <div className="auth-form__field">
            <input
              type="tel"
              className="auth-form__input"
              placeholder="Phone Number *"
              value={phone}
              onChange={(e) => setPhone(e.target.value)}
              autoComplete="tel"
            />
          </div>

          <div className="auth-form__field auth-form__field--password">
            <input
              type={showPassword ? 'text' : 'password'}
              className="auth-form__input"
              placeholder="Password (min 8 characters) *"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              autoComplete="new-password"
            />
            <button
              type="button"
              className="auth-form__toggle-password"
              onClick={() => setShowPassword((v) => !v)}
              aria-label={showPassword ? 'Ẩn mật khẩu' : 'Hiện mật khẩu'}
            >
              {showPassword ? <FiEyeOff size={18} /> : <FiEye size={18} />}
            </button>
          </div>

          <p className="auth-form__legal">
            You are agreeing to the{' '}
            <a href="#terms" className="auth-form__link">Terms of Services</a>
            {' '}and{' '}
            <a href="#privacy" className="auth-form__link">Privacy Policy</a>
          </p>

          <button
            type="submit"
            className="auth-form__submit"
            disabled={loading}
          >
            {loading ? 'Please wait…' : 'Get started'}
          </button>
        </form>

        <p className="auth-form__footer">
          Already a member?{' '}
          <Link to="/login" className="auth-form__link">
            Sign in
          </Link>
        </p>
      </div>
    </AuthLayout>
  );
}

export default SignUp;
