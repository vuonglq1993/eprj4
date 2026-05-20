import React, { useEffect, useState, useRef } from 'react';
import '../styles/setting.css'
import { useAuth } from '../contexts/AuthContext';
import { getProfile, updateProfile } from '../services/userService';
import { getApiErrorMessage } from '../utils/apiError';

const TIMEZONES = [
  'Asia/Ho_Chi_Minh',
  'Asia/Bangkok',
  'Asia/Singapore',
  'Asia/Tokyo',
  'Asia/Seoul',
  'Asia/Dubai',
  'Europe/London',
  'Europe/Paris',
  'Europe/Berlin',
  'America/New_York',
  'America/Los_Angeles',
  'America/Chicago',
  'Pacific/Honolulu',
];

const Setting = () => {
  const { user } = useAuth();
  const fileInputRef = useRef(null);

  const [form, setForm] = useState({
    firstName: '',
    lastName: '',
    email: '',
    phone: '',
    bio: '',
    timezone: '',
    avatarUrl: '',
  });

  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [saveMsg, setSaveMsg] = useState('');
  const [error, setError] = useState('');

  useEffect(() => {
    if (user) {
      setForm((prev) => ({
        ...prev,
        firstName: user.firstName || '',
        lastName: user.lastName || '',
        email: user.email || '',
      }));
    }

    getProfile()
      .then((res) => {
        const p = res.data || {};
        setForm((prev) => ({
          ...prev,
          firstName: p.firstName || prev.firstName || '',
          lastName: p.lastName || prev.lastName || '',
          email: p.email || prev.email || '',
          phone: p.phone || '',
          bio: p.bio || '',
          timezone: p.timezone || '',
          avatarUrl: p.avatarUrl || '',
        }));
      })
      .catch(() => {})
      .finally(() => setLoading(false));
  }, [user]);

  const handleChange = (field) => (e) => {
    setForm((prev) => ({ ...prev, [field]: e.target.value }));
  };

  const handleAvatarChange = (e) => {
    const file = e.target.files?.[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = (ev) => {
      const dataUrl = ev.target.result;
      // Validate size (max 1MB)
      if (file.size > 1024 * 1024) {
        setError('Kích thước ảnh tối đa 1MB. Hãy chọn ảnh nhỏ hơn.');
        return;
      }
      setForm((prev) => ({ ...prev, avatarUrl: dataUrl }));
    };
    reader.readAsDataURL(file);
  };

  const handleDeleteAvatar = () => {
    setForm((prev) => ({ ...prev, avatarUrl: '' }));
    if (fileInputRef.current) fileInputRef.current.value = '';
  };

  const handleSave = async (e) => {
    e.preventDefault();
    setError('');
    setSaveMsg('');
    setSaving(true);
    try {
      await updateProfile({
        firstName: form.firstName.trim(),
        lastName: form.lastName.trim(),
        phone: form.phone.trim(),
        avatarUrl: form.avatarUrl,
        bio: form.bio.trim(),
        timezone: form.timezone,
      });
      setSaveMsg('Lưu thành công!');
    } catch (err) {
      setError((err.response?.status === 409 ? 'Đã tồn tại.' : getApiErrorMessage(err)) || 'Lưu thất bại. Vui lòng thử lại.');
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return (
      <div className="setting-container">
        <div style={{ padding: '40px', textAlign: 'center', color: '#64748b' }}>Đang tải…</div>
      </div>
    );
  }

  return (
    <div className="setting-container">
      {/* Header */}
      <div className="setting-header">
        <div className="header-info">
          <h1>Setting Details</h1>
          <p>Update your photo and personal details here.</p>
        </div>
        <div className="header-actions">
          <button className="btn-cancel" type="button" onClick={() => window.location.reload()}>Cancel</button>
          <button className="btn-save" type="button" onClick={handleSave} disabled={saving}>
            {saving ? 'Saving…' : 'Save'}
          </button>
        </div>
      </div>

      {error && (
        <div style={{ margin: '0 24px 16px', padding: '12px 16px', background: '#fee2e2', color: '#991b1b', borderRadius: 8, fontSize: 14 }}>
          {error}
        </div>
      )}
      {saveMsg && (
        <div style={{ margin: '0 24px 16px', padding: '12px 16px', background: '#d1fae5', color: '#065f46', borderRadius: 8, fontSize: 14 }}>
          {saveMsg}
        </div>
      )}

      <form onSubmit={handleSave}>
        <div className="setting-content">
          {/* Cột trái: Form */}
          <div className="card form-card">
            <h2 className="card-title">Personal information</h2>
            <div className="form-grid">
              <div className="input-group">
                <label>First Name</label>
                <input
                  type="text"
                  placeholder="Enter first name"
                  value={form.firstName}
                  onChange={handleChange('firstName')}
                  maxLength={50}
                />
              </div>
              <div className="input-group">
                <label>Last Name</label>
                <input
                  type="text"
                  placeholder="Enter last name"
                  value={form.lastName}
                  onChange={handleChange('lastName')}
                  maxLength={50}
                />
              </div>
              <div className="input-group">
                <label>Email Address</label>
                <input
                  type="email"
                  placeholder="Enter email address"
                  value={form.email}
                  onChange={handleChange('email')}
                  readOnly
                  style={{ background: '#f1f5f9', cursor: 'not-allowed', color: '#64748b' }}
                />
              </div>
              <div className="input-group">
                <label>Phone No</label>
                <input
                  type="tel"
                  placeholder="Enter phone number"
                  value={form.phone}
                  onChange={handleChange('phone')}
                  maxLength={20}
                />
              </div>
              <div className="input-group full-width">
                <label>Bio (Short introduction)</label>
                <textarea
                  rows="4"
                  placeholder="Tell us about yourself..."
                  value={form.bio}
                  onChange={handleChange('bio')}
                  maxLength={500}
                />
              </div>
              <div className="input-group full-width">
                <label>Timezone</label>
                <select
                  value={form.timezone}
                  onChange={handleChange('timezone')}
                  style={{
                    width: '100%',
                    padding: '10px 14px',
                    borderRadius: 8,
                    border: '1px solid #e2e8f0',
                    fontSize: 14,
                    color: '#334155',
                    background: '#fff',
                    outline: 'none',
                  }}
                >
                  <option value="">Select timezone…</option>
                  {TIMEZONES.map((tz) => (
                    <option key={tz} value={tz}>{tz}</option>
                  ))}
                </select>
              </div>
            </div>
          </div>

          <div className="side-column">
            <div className="card photo-card">
              <h2 className="card-title">Your Photo</h2>
              <div className="photo-edit">
                <div style={{
                  width: 80,
                  height: 80,
                  borderRadius: '50%',
                  background: form.avatarUrl ? 'transparent' : '#8b5cf6',
                  overflow: 'hidden',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  color: '#fff',
                  fontSize: 28,
                  fontWeight: 700,
                  flexShrink: 0,
                }}>
                  {form.avatarUrl ? (
                    <img
                      src={form.avatarUrl}
                      alt="Avatar"
                      style={{ width: '100%', height: '100%', objectFit: 'cover' }}
                    />
                  ) : (
                    (form.firstName?.[0] || form.email?.[0] || 'U').toUpperCase()
                  )}
                </div>
                <div className="photo-controls">
                  <p>Edit your photo</p>
                  {form.avatarUrl && (
                    <button type="button" className="text-delete" onClick={handleDeleteAvatar}>Delete</button>
                  )}
                  <button type="button" className="text-update" onClick={() => fileInputRef.current?.click()}>Update</button>
                </div>
              </div>

              <input
                ref={fileInputRef}
                type="file"
                accept="image/jpeg,image/png,image/gif,image/webp"
                style={{ display: 'none' }}
                onChange={handleAvatarChange}
              />

              <div className="upload-box">
                <div className="upload-icon">↑</div>
                <p><span>Click to upload</span> or drag and drop</p>
                <small>SVG, PNG, JPG (Max 1MB)</small>
              </div>
            </div>

            <div className="card google-card">
              <div className="google-header">
                <span className="google-logo">Google</span>
                <span className="status-badge">Connected</span>
              </div>
              <p>Use Google to sign in to your account. <a href="#">Learn more</a></p>
            </div>
          </div>
        </div>
      </form>
    </div>
  );
};

export default Setting;
