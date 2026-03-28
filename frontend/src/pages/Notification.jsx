import React from 'react';
import { FiSearch, FiX } from 'react-icons/fi';

const Notification = () => {
    const alerts = [
        { id: 1, type: 'primary', text: 'A simple primary alert with an example link. Give it a click if you like.' },
        { id: 2, type: 'secondary', text: 'A simple secondary alert with an example link. Give it a click if you like.' },
        { id: 3, type: 'success', text: 'A simple success alert with an example link. Give it a click if you like.' },
        { id: 4, type: 'danger', text: 'A simple danger alert with an example link. Give it a click if you like.' },
        { id: 5, type: 'warning', text: 'A simple warning alert with an example link. Give it a click if you like.' },
        { id: 6, type: 'info', text: 'A simple info alert with an example link. Give it a click if you like.' },
        { id: 7, type: 'light', text: 'A simple light alert with an example link. Give it a click if you like.' },
    ];

    const toasts = [
        { id: 1, title: 'Success Notification', color: '#6366f1' },
        { id: 2, title: 'Warning Notification', color: '#00d2ff' },
        { id: 3, title: 'Danger Notification', color: '#ff4d4d' },
        { id: 4, title: 'Secondary Notification', color: '#8b5cf6' },
    ];

    return (
        <div className="notification-page">
            <div className="notification-section">
                <div className="alert-card">
                    <h2 className="section-title">Alert</h2>
                    <div className="alert-list">
                        {alerts.map((alert) => (
                            <div key={alert.id} className={`alert-item alert-${alert.type}`}>
                                <span>{alert.text} <a href="#">an example link</a></span>
                                <FiX className="close-icon" />
                            </div>
                        ))}
                    </div>
                </div>
            </div>
            <div className="notification-section">
                <div className="toast-card">
                    <h2 className="section-title">Notification</h2>
                    <p className="section-desc">
                        Notifications on this page use Toasts from Bootstrap. Read more details here.
                    </p>
                    <div className="toast-grid">
                        {toasts.map((toast) => (
                            <div key={toast.id} className="toast-box" style={{ backgroundColor: toast.color }}>
                                {toast.title}
                            </div>
                        ))}
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Notification;