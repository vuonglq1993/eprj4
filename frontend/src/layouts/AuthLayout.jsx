import React from 'react';
import '../styles/auth.css';

function AuthLayout({ children, headline, subline, adminMode = false }) {
  return (
    <div className="auth-layout">
      <div className="auth-layout__form-col">
        <div className="auth-layout__form-inner">{children}</div>
      </div>
      <div className={`auth-layout__panel${adminMode ? ' auth-layout__panel--admin' : ''}`}>
        <div className="auth-layout__panel-content">
          {adminMode ? (
            <>
              <div className="auth-layout__admin-icon" aria-hidden>⚙️</div>
              <h2 className="auth-layout__headline">{headline}</h2>
              <p className="auth-layout__subline">{subline}</p>
              <p className="auth-layout__admin-desc">
                Quản lý khoá học, người dùng và nội dung học tập một cách dễ dàng.
              </p>
            </>
          ) : (
            <>
              <div className="auth-layout__deco-lines" aria-hidden />
              <h2 className="auth-layout__headline">{headline}</h2>
              <p className="auth-layout__subline">{subline}</p>
              <div
                className="auth-layout__image"
                role="img"
                aria-label="Person with laptop"
              />
            </>
          )}
        </div>
      </div>
    </div>
  );
}

export default AuthLayout
