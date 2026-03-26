import React from 'react';
import '../styles/auth.css';
function AuthLayout({ children, headline, subline }) {
  return (
    <div className="auth-layout">
      <div className="auth-layout__form-col">
        <div className="auth-layout__form-inner">{children}</div>
      </div>
      <div className="auth-layout__panel">
        <div className="auth-layout__panel-content">
          <div className="auth-layout__deco-lines" aria-hidden />
          <h2 className="auth-layout__headline">{headline}</h2>
          <p className="auth-layout__subline">{subline}</p>
          <div
            className="auth-layout__image"
            role="img"
            aria-label="Person with laptop"
          />
        </div>
      </div>
    </div>
  )
}

export default AuthLayout
