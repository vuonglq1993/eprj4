import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import AuthLayout from '../layouts/AuthLayout'
import { FcGoogle } from 'react-icons/fc'
import { FaFacebook } from 'react-icons/fa'

function Login() {
  const navigate = useNavigate()
  const { login } = useAuth()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  const handleSubmit = (e) => {
    e.preventDefault()
    setError('')
    setLoading(true)
    const result = login(email, password)
    setLoading(false)
    if (result.success) {
      navigate('/', { replace: true })
    } else {
      setError(result.message || 'Đăng nhập thất bại.')
    }
  }

  return (
    <AuthLayout
      headline="Very good works are"
      subline="waiting for you — Sign up Now"
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
              required
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
              required
            />
            <div className="auth-form__field-footer">
              <Link to="/forgot-password" className="auth-form__link">
                Forgot password
              </Link>
            </div>
          </div>

          <button
            type="submit"
            className="auth-form__submit"
            disabled={loading}
          >
            {loading ? 'Signing in…' : 'Sign in'}
          </button>
        </form>

        <div className="auth-form__social">
          <button type="button" className="auth-form__social-btn">
            <FcGoogle size={20} />
            <span>Sign in with Google</span>
          </button>
          <button type="button" className="auth-form__social-btn">
            <FaFacebook size={20} style={{ color: '#1877f2' }} />
            <span>Sign in with Facebook</span>
          </button>
        </div>

        <p className="auth-form__footer">
          Don&apos;t have an account.{' '}
          <Link to="/signup" className="auth-form__link">
            Sign up
          </Link>
        </p>
      </div>
    </AuthLayout>
  )
}

export default Login
