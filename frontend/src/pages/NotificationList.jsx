import React, { useState, useEffect, useCallback } from 'react';
import '../styles/notificationlist.css';
import {
  FiSend, FiBell, FiUsers, FiCheckCircle, FiAlertCircle,
  FiClock, FiActivity, FiSearch, FiX
} from 'react-icons/fi';
import {
  broadcastNotification,
  sendNotification,
  getBroadcastHistory,
  searchUsers,
} from '../services/notificationService';

const NOTIF_TYPES = [
  { value: 'SYSTEM', label: 'System' },
  { value: 'ANNOUNCEMENT', label: 'Announcement' },
  { value: 'PROMOTION', label: 'Promotion' },
  { value: 'MAINTENANCE', label: 'Maintenance' },
  { value: 'STUDY_REMINDER', label: 'Study Reminder' },
  { value: 'ACHIEVEMENT', label: 'Achievement' },
];

const TYPE_COLORS = {
  SYSTEM: 'badge-system',
  ANNOUNCEMENT: 'badge-announcement',
  PROMOTION: 'badge-promotion',
  MAINTENANCE: 'badge-maintenance',
  STUDY_REMINDER: 'badge-study',
  ACHIEVEMENT: 'badge-achievement',
};

const TABS = [
  { id: 'broadcast', label: 'Gửi Broadcast', icon: FiSend },
  { id: 'personal', label: 'Gửi cá nhân', icon: FiUsers },
  { id: 'history', label: 'Lịch sử', icon: FiClock },
];

const NotificationList = () => {
  const [activeTab, setActiveTab] = useState('broadcast');

  // ── Broadcast state ──────────────────────────────────────
  const [bcForm, setBcForm] = useState({ title: '', body: '', type: 'ANNOUNCEMENT' });
  const [bcSending, setBcSending] = useState(false);
  const [bcResult, setBcResult] = useState(null);
  const [bcErrors, setBcErrors] = useState({});

  // ── Personal send state ──────────────────────────────────
  const [ptForm, setPtForm] = useState({ userId: '', title: '', body: '', type: 'ANNOUNCEMENT' });
  const [ptSending, setPtSending] = useState(false);
  const [ptResult, setPtResult] = useState(null);
  const [ptErrors, setPtErrors] = useState({});

  // ── User search state ───────────────────────────────────
  const [userQuery, setUserQuery] = useState('');
  const [userResults, setUserResults] = useState([]);
  const [userLoading, setUserLoading] = useState(false);
  const [showDropdown, setShowDropdown] = useState(false);

  // ── History state ───────────────────────────────────────
  const [history, setHistory] = useState([]);
  const [historyLoading, setHistoryLoading] = useState(false);

  // ── Load history ─────────────────────────────────────────
  const loadHistory = () => {
    setHistoryLoading(true);
    getBroadcastHistory(50)
      .then(({ data }) => setHistory(Array.isArray(data) ? data : []))
      .catch(() => setHistory([]))
      .finally(() => setHistoryLoading(false));
  };

  useEffect(() => {
    if (activeTab === 'history') loadHistory();
  }, [activeTab]);

  // ── User search ───────────────────────────────────────────
  const searchUserDebounced = useCallback(
    (() => {
      let timer;
      return (q) => {
        clearTimeout(timer);
        if (!q.trim()) {
          setUserResults([]);
          setShowDropdown(false);
          return;
        }
        setUserLoading(true);
        timer = setTimeout(() => {
          searchUsers(q)
            .then(({ data }) => {
              setUserResults(Array.isArray(data) ? data : []);
              setShowDropdown(true);
            })
            .catch(() => setUserResults([]))
            .finally(() => setUserLoading(false));
        }, 300);
      };
    })(),
    []
  );

  const selectUser = (user) => {
    setPtForm(prev => ({ ...prev, userId: user.id }));
    setUserQuery(`${user.name} (${user.email})`);
    setUserResults([]);
    setShowDropdown(false);
  };

  const clearUser = () => {
    setPtForm(prev => ({ ...prev, userId: '' }));
    setUserQuery('');
    setUserResults([]);
    setShowDropdown(false);
  };

  // ── Handlers ─────────────────────────────────────────────
  const handleBroadcast = async (e) => {
    e.preventDefault();
    const errs = {};
    if (!bcForm.title.trim()) errs.title = 'Tiêu đề không được để trống.';
    if (!bcForm.body.trim()) errs.body = 'Nội dung không được để trống.';
    if (Object.keys(errs).length) { setBcErrors(errs); return; }
    setBcErrors({});
    setBcSending(true);
    setBcResult(null);
    try {
      const { data } = await broadcastNotification({
        title: bcForm.title.trim(),
        body: bcForm.body.trim(),
        type: bcForm.type,
      });
      setBcResult({ success: true, message: data?.message || 'Đã gửi broadcast thành công!' });
      setBcForm({ title: '', body: '', type: 'ANNOUNCEMENT' });
      if (activeTab === 'history') loadHistory();
    } catch (err) {
      setBcResult({ success: false, message: err.response?.data?.message || 'Gửi thất bại.' });
    } finally {
      setBcSending(false);
    }
  };

  const handleSendPersonal = async (e) => {
    e.preventDefault();
    const errs = {};
    if (!ptForm.userId.trim()) errs.userId = 'Vui lòng chọn người nhận.';
    if (!ptForm.title.trim()) errs.title = 'Tiêu đề không được để trống.';
    if (!ptForm.body.trim()) errs.body = 'Nội dung không được để trống.';
    if (Object.keys(errs).length) { setPtErrors(errs); return; }
    setPtErrors({});
    setPtSending(true);
    setPtResult(null);
    try {
      const { data } = await sendNotification(ptForm.userId.trim(), {
        title: ptForm.title.trim(),
        body: ptForm.body.trim(),
        type: ptForm.type,
      });
      setPtResult({ success: true, message: data?.message || `Đã gửi đến user ${ptForm.userId}` });
      setPtForm({ userId: '', title: '', body: '', type: 'ANNOUNCEMENT' });
      setUserQuery('');
    } catch (err) {
      setPtResult({ success: false, message: err.response?.data?.message || 'Gửi thất bại.' });
    } finally {
      setPtSending(false);
    }
  };

  const dismissResult = (setter) => setTimeout(() => setter(null), 6000);

  // ── Format date ──────────────────────────────────────────
  const formatDate = (dateStr) => {
    if (!dateStr) return '—';
    const d = new Date(dateStr);
    return d.toLocaleString('vi-VN', {
      day: '2-digit', month: '2-digit', year: 'numeric',
      hour: '2-digit', minute: '2-digit',
    });
  };

  // ──────────────────────────────────────────────────────────
  return (
    <div className="nl-page py-4 px-3">
      <div className="nl-inner mx-auto">

        {/* Page Header */}
        <div className="nl-page-header mb-4">
          <div className="d-flex align-items-center gap-3">
            <div className="nl-header-icon">
              <FiBell size={22} />
            </div>
            <div>
              <h1 className="nl-page-title">Quản lý Thông báo</h1>
              <p className="nl-page-subtitle">Gửi push notification qua Firebase Cloud Messaging</p>
            </div>
          </div>
        </div>

        {/* Tab Nav */}
        <div className="nl-tabs mb-4">
          {TABS.map((tab) => {
            const Icon = tab.icon;
            return (
              <button
                key={tab.id}
                type="button"
                className={`nl-tab ${activeTab === tab.id ? 'nl-tab--active' : ''}`}
                onClick={() => setActiveTab(tab.id)}
              >
                <Icon size={15} />
                {tab.label}
              </button>
            );
          })}
        </div>

        {/* ── TAB 1: Broadcast ─────────────────────────── */}
        {activeTab === 'broadcast' && (
          <div className="nl-content animate-fade">
            <div className="nl-grid nl-grid--single">
              <div className="nl-card">
                <div className="nl-card__header nl-card__header--broadcast">
                  <div className="nl-card__icon nl-card__icon--broadcast">
                    <FiSend size={20} />
                  </div>
                  <div>
                    <h5 className="nl-card__title mb-1">Broadcast Notification</h5>
                    <p className="text-muted small mb-0">Gửi thông báo đến TẤT CẢ người dùng (FCM Topic)</p>
                  </div>
                </div>

                {bcResult && (
                  <div className={`nl-banner ${bcResult.success ? 'nl-banner--success' : 'nl-banner--error'}`}>
                    <div className="d-flex align-items-center gap-2">
                      {bcResult.success ? <FiCheckCircle size={16} /> : <FiAlertCircle size={16} />}
                      <span>{bcResult.message}</span>
                    </div>
                    <button type="button" className="nl-banner__close"
                      onClick={() => { setBcResult(null); dismissResult(setBcResult); }}>×</button>
                  </div>
                )}

                <form onSubmit={handleBroadcast} noValidate>
                  <div className="nl-card__body">
                    <div className="nl-field">
                      <label className="nl-label">Tiêu đề <span className="text-danger">*</span></label>
                      <input
                        className={`nl-input${bcErrors.title ? ' is-invalid' : ''}`} type="text"
                        placeholder="Ví dụ: Chào mừng bạn đến với LanguageApp!"
                        value={bcForm.title}
                        onChange={(e) => setBcForm({ ...bcForm, title: e.target.value })}
                        maxLength={100}
                      />
                      {bcErrors.title ? <div className="invalid-feedback">{bcErrors.title}</div> : <small className="nl-hint">{bcForm.title.length}/100</small>}
                    </div>
                    <div className="nl-field">
                      <label className="nl-label">Nội dung <span className="text-danger">*</span></label>
                      <textarea
                        className={`nl-textarea${bcErrors.body ? ' is-invalid' : ''}`} rows={3}
                        placeholder="Nhập nội dung thông báo..."
                        value={bcForm.body}
                        onChange={(e) => setBcForm({ ...bcForm, body: e.target.value })}
                        maxLength={500}
                      />
                      {bcErrors.body ? <div className="invalid-feedback">{bcErrors.body}</div> : <small className="nl-hint">{bcForm.body.length}/500</small>}
                    </div>
                    <div className="nl-field">
                      <label className="nl-label">Loại thông báo</label>
                      <select
                        className="nl-select"
                        value={bcForm.type}
                        onChange={(e) => setBcForm({ ...bcForm, type: e.target.value })}
                      >
                        {NOTIF_TYPES.map((t) => (
                          <option key={t.value} value={t.value}>{t.label}</option>
                        ))}
                      </select>
                    </div>
                  </div>
                  <div className="nl-card__footer">
                    <button type="submit" className="nl-btn nl-btn--primary" disabled={bcSending}>
                      <FiSend size={14} />
                      {bcSending ? 'Đang gửi broadcast...' : 'Gửi Broadcast'}
                    </button>
                  </div>
                </form>
              </div>
            </div>

            <div className="nl-info-box">
              <div className="nl-info-box__icon"><FiActivity size={16} /></div>
              <div>
                <strong>Cách hoạt động:</strong>
                <ul className="mb-0 mt-1">
                  <li>Broadcast gửi đến FCM Topic <code>all_users</code> — <strong>1 request</strong> gửi đến tất cả thiết bị.</li>
                  <li>Mỗi user có app đăng ký topic <code>all_users</code> sẽ nhận notification.</li>
                  <li>Lịch sử broadcast được lưu trong <strong>Firestore</strong> (collection <code>app_notifications</code>).</li>
                </ul>
              </div>
            </div>
          </div>
        )}

        {/* ── TAB 2: Personal ───────────────────────────── */}
        {activeTab === 'personal' && (
          <div className="nl-content animate-fade">
            <div className="nl-grid nl-grid--single">
              <div className="nl-card">
                <div className="nl-card__header nl-card__header--personal">
                  <div className="nl-card__icon nl-card__icon--personal">
                    <FiUsers size={20} />
                  </div>
                  <div>
                    <h5 className="nl-card__title mb-1">Gửi đến 1 User</h5>
                    <p className="text-muted small mb-0">Nhắn riêng cho người dùng cụ thể (FCM token)</p>
                  </div>
                </div>

                {ptResult && (
                  <div className={`nl-banner ${ptResult.success ? 'nl-banner--success' : 'nl-banner--error'}`}>
                    <div className="d-flex align-items-center gap-2">
                      {ptResult.success ? <FiCheckCircle size={16} /> : <FiAlertCircle size={16} />}
                      <span>{ptResult.message}</span>
                    </div>
                    <button type="button" className="nl-banner__close"
                      onClick={() => { setPtResult(null); dismissResult(setPtResult); }}>×</button>
                  </div>
                )}

                <form onSubmit={handleSendPersonal} noValidate>
                  <div className="nl-card__body">
                    {/* User search */}
                    <div className="nl-field">
                      <label className="nl-label">Người nhận <span className="text-danger">*</span></label>
                      <div className="nl-input-icon-wrap">
                        <FiSearch size={15} className="nl-input-icon" />
                        <input
                          className="nl-input nl-input--icon"
                          type="text"
                          placeholder="Nhập email để tìm user..."
                          value={userQuery}
                          onChange={(e) => {
                            setUserQuery(e.target.value);
                            searchUserDebounced(e.target.value);
                          }}
                          onFocus={() => { if (userResults.length > 0) setShowDropdown(true); }}
                          autoComplete="off"
                        />
                        {ptForm.userId && (
                          <button type="button" className="nl-input-clear-btn" onClick={clearUser}>
                            <FiX size={14} />
                          </button>
                        )}
                      </div>

                      {/* Search dropdown */}
                      {showDropdown && (
                        <div className="nl-user-dropdown">
                          {userLoading ? (
                            <div className="nl-user-dropdown__item nl-user-dropdown__item--loading">
                              Đang tìm...
                            </div>
                          ) : userResults.length === 0 ? (
                            <div className="nl-user-dropdown__item nl-user-dropdown__item--empty">
                              Không tìm thấy user
                            </div>
                          ) : (
                            userResults.map((u) => (
                              <button
                                key={u.id}
                                type="button"
                                className="nl-user-dropdown__item"
                                onClick={() => selectUser(u)}
                              >
                                <div className="nl-user-dropdown__avatar">
                                  {u.name ? u.name[0].toUpperCase() : '?'}
                                </div>
                                <div>
                                  <div className="nl-user-dropdown__name">{u.name || '—'}</div>
                                  <div className="nl-user-dropdown__email">{u.email}</div>
                                </div>
                                <span className="nl-user-dropdown__role">{u.role}</span>
                              </button>
                            ))
                          )}
                        </div>
                      )}

                      {ptForm.userId ? (
                        <small className="nl-hint nl-hint--success">✓ Đã chọn: {ptForm.userId}</small>
                      ) : ptErrors.userId ? (
                        <div className="invalid-feedback">{ptErrors.userId}</div>
                      ) : null}
                    </div>

                    <div className="nl-field">
                      <label className="nl-label">Tiêu đề <span className="text-danger">*</span></label>
                      <input
                        className={`nl-input${ptErrors.title ? ' is-invalid' : ''}`} type="text"
                        placeholder="Tiêu đề thông báo"
                        value={ptForm.title}
                        onChange={(e) => setPtForm({ ...ptForm, title: e.target.value })}
                        maxLength={100}
                      />
                      {ptErrors.title && <div className="invalid-feedback">{ptErrors.title}</div>}
                    </div>
                    <div className="nl-field">
                      <label className="nl-label">Nội dung <span className="text-danger">*</span></label>
                      <textarea
                        className={`nl-textarea${ptErrors.body ? ' is-invalid' : ''}`} rows={2}
                        placeholder="Nội dung thông báo"
                        value={ptForm.body}
                        onChange={(e) => setPtForm({ ...ptForm, body: e.target.value })}
                        maxLength={500}
                      />
                      {ptErrors.body && <div className="invalid-feedback">{ptErrors.body}</div>}
                    </div>
                    <div className="nl-field">
                      <label className="nl-label">Loại thông báo</label>
                      <select
                        className="nl-select"
                        value={ptForm.type}
                        onChange={(e) => setPtForm({ ...ptForm, type: e.target.value })}
                      >
                        {NOTIF_TYPES.map((t) => (
                          <option key={t.value} value={t.value}>{t.label}</option>
                        ))}
                      </select>
                    </div>
                  </div>
                  <div className="nl-card__footer">
                    <button type="submit" className="nl-btn nl-btn--outline" disabled={ptSending}>
                      <FiSend size={14} />
                      {ptSending ? 'Đang gửi...' : 'Gửi đến User'}
                    </button>
                  </div>
                </form>
              </div>
            </div>

            <div className="nl-info-box">
              <div className="nl-info-box__icon"><FiActivity size={16} /></div>
              <div>
                <strong>Cách hoạt động:</strong>
                <ul className="mb-0 mt-1">
                  <li>Gửi trực tiếp đến FCM token của user đó — notification hiện trên thiết bị của họ.</li>
                  <li>Tìm user bằng <strong>email</strong> — kết quả hiện tên + role.</li>
                  <li>Lịch sử notification được lưu trong Firestore (collection <code>notifications</code>).</li>
                </ul>
              </div>
            </div>
          </div>
        )}

        {/* ── TAB 3: History ───────────────────────────── */}
        {activeTab === 'history' && (
          <div className="nl-content animate-fade">
            <div className="nl-card">
              <div className="nl-card__header nl-card__header--history">
                <div className="nl-card__icon nl-card__icon--history">
                  <FiClock size={20} />
                </div>
                <div className="flex-grow-1">
                  <h5 className="nl-card__title mb-1">Lịch sử Broadcast</h5>
                  <p className="text-muted small mb-0">Danh sách thông báo đã gửi (mới nhất trước)</p>
                </div>
                <button
                  type="button" className="nl-btn nl-btn--ghost"
                  onClick={loadHistory} disabled={historyLoading}
                >
                  <FiActivity size={14} />
                  {historyLoading ? 'Đang tải...' : 'Làm mới'}
                </button>
              </div>

              <div className="nl-card__body p-0">
                {historyLoading ? (
                  <div className="nl-empty">
                    <div className="nl-empty__spinner" />
                    <span>Đang tải lịch sử...</span>
                  </div>
                ) : history.length === 0 ? (
                  <div className="nl-empty">
                    <FiBell size={36} className="nl-empty__icon" />
                    <p className="nl-empty__text">Chưa có thông báo nào được gửi</p>
                  </div>
                ) : (
                  <div className="nl-table-wrap">
                    <table className="nl-table">
                      <thead>
                        <tr>
                          <th>Tiêu đề</th>
                          <th>Nội dung</th>
                          <th>Loại</th>
                          <th>Người nhận</th>
                          <th>Thời gian</th>
                        </tr>
                      </thead>
                      <tbody>
                        {history.map((item) => (
                          <tr key={item.id}>
                            <td>
                              <span className="nl-history-title">{item.title}</span>
                            </td>
                            <td>
                              <span className="nl-history-body">{item.body}</span>
                            </td>
                            <td>
                              <span className={`nl-badge ${TYPE_COLORS[item.type] || 'badge-system'}`}>
                                {item.type}
                              </span>
                            </td>
                            <td>
                              <span className="nl-history-count">
                                <FiUsers size={12} />
                                {item.recipientCount ?? '?'} user
                              </span>
                            </td>
                            <td>
                              <span className="nl-history-date">{formatDate(item.sentAt)}</span>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                )}
              </div>
            </div>
          </div>
        )}

      </div>
    </div>
  );
};

export default NotificationList;
