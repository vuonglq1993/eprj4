import React from 'react';
import { FiMoreVertical } from 'react-icons/fi';

const SecuritySetting = () => {
  // Dữ liệu mô phỏng cho danh sách thiết bị (từ hình 1 và 2)
  const devices = [
    { id: 1, name: 'iPhone 11', location: 'London, UK', time: 'Oct12 at 2:30AM' },
    { id: 2, name: 'Galaxy 18', location: 'Berlin', time: 'Nov23 at 2:30PM' },
    { id: 3, name: 'Vivo y21', location: 'London, UK', time: 'Oct12 at 2:30AM' },
    { id: 4, name: 'iPhone 12', location: 'London, UK', time: 'Oct12 at 2:30AM' },
    { id: 5, name: 'Samsung', location: 'Karachi, PAK', time: 'Oct12 at 2:30AM' },
  ];

  return (
    <div className="security-settings-page">
      <div className="container-fluid px-5 py-4">
        {/* Tiêu đề trang chính */}
        <h1 className="main-page-title mb-5">Security Setting</h1>

        <div className="row g-5">
          {/* Cột bên trái: Đổi mật khẩu & Quy tắc (Hình 1 & 2) */}
          <div className="col-lg-8">
            <div className="settings-card shadow-sm p-5 bg-white mb-5">
              <div className="card-head-content mb-5">
                <h2 className="settings-card-title">Password</h2>
                <p className="settings-card-subtitle text-muted">
                  The Last Pass password generator creates random passwords based on parameters set by you.
                </p>
              </div>

              <form className="password-form">
                <div className="mb-4">
                  <label className="form-label fw-semibold">Current password</label>
                  <input type="password" className="form-control custom-input" placeholder="Current password" />
                </div>
                <div className="mb-4">
                  <label className="form-label fw-semibold">New password</label>
                  <input type="password" className="form-control custom-input" placeholder="New password" />
                </div>
                <div className="mb-5">
                  <label className="form-label fw-semibold">Confirm password</label>
                  <input type="password" className="form-control custom-input" placeholder="Confirm password" />
                </div>
              </form>
            </div>

            {/* Khối quy tắc mật khẩu (Hình 2) */}
            <div className="settings-card shadow-sm p-5 bg-gray-light">
              <div className="card-head-content mb-4">
                <h3 className="settings-card-title h4">Rules for password</h3>
                <p className="settings-card-subtitle text-muted small">
                  To create a new password, you have to meet all of the following requirements.
                </p>
              </div>
              <ul className="password-rules-list text-muted small">
                <li>Minimum 8 characters</li>
                <li>At least one special character</li>
                <li>At least one number</li>
                <li>Can't be the same as a previous</li>
              </ul>
            </div>
          </div>

          {/* Cột bên phải: Quản lý thiết bị (Hình 1 & 2) */}
          <div className="col-lg-4">
            <div className="devices-card shadow-sm p-5 bg-white h-100 d-flex flex-column">
              <div className="card-head-content mb-4">
                <h2 className="settings-card-title">Devices</h2>
                <p className="settings-card-subtitle text-muted small">
                  The Last Pass password generator creates random passwords based on parameters set by you.
                </p>
              </div>

              {/* Nút đăng xuất tất cả */}
              <button className="btn-sign-out-all mb-4">Sign out from all devices</button>

              <div className="divider mb-4"></div>

              {/* Danh sách thiết bị */}
              <div className="device-list flex-grow-1">
                {devices.map((device) => (
                  <div key={device.id} className="device-item d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom-faint">
                    <div className="device-info">
                      <h6 className="device-name mb-1 fw-semibold">{device.name}</h6>
                      <p className="device-meta text-muted small mb-0">
                        {device.location}, {device.time}
                      </p>
                    </div>
                    <button className="btn-more-actions p-0">
                      <FiMoreVertical className="text-muted" />
                    </button>
                  </div>
                ))}
              </div>

              {/* Nút trợ giúp ở cuối card (Hình 2) */}
              <div className="mt-auto pt-4">
                <button className="btn-need-help w-100">Need help?</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default SecuritySetting;