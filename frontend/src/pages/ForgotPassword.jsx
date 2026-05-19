import { useState } from 'react'
import { Link } from 'react-router-dom'
import AuthLayout from '../layouts/AuthLayout'

function ForgotPassword() {
  const [email, setEmail] = useState('')
  const [sent, setSent] = useState(false)
  const [emailError, setEmailError] = useState('')

  const handleSubmit = (e) => {
    e.preventDefault()
    if (!email.trim()) { setEmailError('Vui lòng nhập email.'); return; }
    setEmailError('')
    setSent(true)
  }

  return (
    <AuthLayout
      headline="Very good works are"
      subline="waiting for you — Sign up Now"
    >
      <div className="auth-form">
        <h1 className="auth-form__title">Forgot password</h1>
        <p className="auth-form__subtitle">
          Enter your email and we&apos;ll send you a reset link (demo only).
        </p>

        {sent ? (
          <p className="auth-form__footer">
            Link gửi thành công (demo). <Link to="/login" className="auth-form__link">Quay lại đăng nhập</Link>
          </p>
        ) : (
          <form className="auth-form__form" onSubmit={handleSubmit} noValidate>
            <div className="auth-form__field">
              <label className="auth-form__label" htmlFor="forgot-email">Email</label>
              <input
                id="forgot-email"
                type="email"
                className="auth-form__input"
                placeholder="Enter your email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
              />
              {emailError && <div className="invalid-feedback" style={{ display: 'block' }}>{emailError}</div>}
            </div>
            <button type="submit" className="auth-form__submit">Send reset link</button>
          </form>
        )}

        <p className="auth-form__footer">
          <Link to="/login" className="auth-form__link">← Back to Sign in</Link>
        </p>
      </div>
    </AuthLayout>
  )
}

export default ForgotPassword
