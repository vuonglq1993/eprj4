import React, { useEffect, useState } from 'react';
import '../styles/adminuser.css';
import { FiEdit2, FiTrash2, FiUser, FiMail, FiShield, FiCheckCircle, FiXCircle } from 'react-icons/fi';
import { getUsers, updateUserRole, deleteUser } from '../services/userService';
import { isAdmin } from '../utils/roleUtils';

const ROLES = ['STUDENT', 'ADMIN'];

const ROLE_CONFIG = {
  ADMIN: { label: 'Admin', className: 'au-role--admin', icon: FiShield },
  STUDENT: { label: 'Student', className: 'au-role--user', icon: null },
};

function RoleBadge({ role }) {
  const cfg = ROLE_CONFIG[role] || ROLE_CONFIG.USER;
  return (
    <span className={`au-role-badge ${cfg.className}`}>
      {cfg.label}
    </span>
  );
}

function StatusBadge({ active }) {
  return active ? (
    <span className="au-status-badge au-status-badge--active">
      <FiCheckCircle size={12} /> Active
    </span>
  ) : (
    <span className="au-status-badge au-status-badge--inactive">
      <FiXCircle size={12} /> Inactive
    </span>
  );
}

function AvatarPlaceholder({ name, size = 40 }) {
  const initials = name
    ? name.split(' ').map((p) => p[0]).join('').slice(0, 2).toUpperCase()
    : '?';
  const colors = ['#6366f1', '#8b5cf6', '#0ea5e9', '#10b981', '#f59e0b', '#ef4444'];
  const color = colors[name ? name.charCodeAt(0) % colors.length : 0];
  return (
    <div
      className="au-avatar"
      style={{
        width: size,
        height: size,
        backgroundColor: color + '22',
        color,
        borderRadius: '50%',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        fontWeight: 700,
        fontSize: size * 0.38,
        flexShrink: 0,
      }}
    >
      {initials}
    </div>
  );
}

function formatDate(iso) {
  if (!iso) return '—';
  try {
    return new Date(iso).toLocaleDateString('vi-VN', { year: 'numeric', month: 'short', day: 'numeric' });
  } catch {
    return iso;
  }
}

const AdminUserManagementPage = () => {
  const admin = isAdmin();
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [deletingId, setDeletingId] = useState(null);
  const [editingId, setEditingId] = useState(null);
  const [editRole, setEditRole] = useState('');
  const [saving, setSaving] = useState(false);
  const [search, setSearch] = useState('');
  const [filterRole, setFilterRole] = useState('');

  const fetchUsers = async () => {
    setLoading(true);
    setError('');
    try {
      const res = await getUsers();
      // Backend trả về Spring Page<UserResponse>: { content: [...], totalElements, totalPages, ... }
      const content = res.data?.content ?? res.data ?? [];
      setUsers(Array.isArray(content) ? content : []);
    } catch (err) {
      setError('Không tải được danh sách người dùng.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchUsers(); }, []);

  const handleDelete = async (id) => {
    if (!window.confirm('Xóa người dùng này? Hành động không thể hoàn tác.')) return;
    setDeletingId(id);
    try {
      await deleteUser(id);
      setUsers((prev) => prev.filter((u) => u.id !== id));
    } catch {
      alert('Xóa thất bại.');
    } finally {
      setDeletingId(null);
    }
  };

  const openEditRole = (user) => {
    setEditingId(user.id);
    setEditRole(user.role || 'STUDENT');
  };

  const cancelEditRole = () => {
    setEditingId(null);
    setEditRole('');
  };

  const saveEditRole = async () => {
    if (!editingId) return;
    setSaving(true);
    try {
      const res = await updateUserRole(editingId, editRole);
      setUsers((prev) =>
        prev.map((u) => (u.id === editingId ? { ...u, role: res.data?.role ?? editRole } : u))
      );
      setEditingId(null);
    } catch (err) {
      alert(err.response?.data?.message || 'Cập nhật vai trò thất bại.');
    } finally {
      setSaving(false);
    }
  };

  const filtered = users.filter((u) => {
    const q = search.toLowerCase();
    const matchSearch =
      !q ||
      (u.firstName || '').toLowerCase().includes(q) ||
      (u.lastName || '').toLowerCase().includes(q) ||
      (u.email || '').toLowerCase().includes(q);
    const matchRole = !filterRole || u.role === filterRole;
    return matchSearch && matchRole;
  });

  const getFullName = (u) =>
    [u.firstName, u.lastName].filter(Boolean).join(' ') || u.email || '—';

  return (
    <div className="au-page py-4 px-3">
      <div className="au-inner mx-auto">
        <div className="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
          <div>
            <h2 className="fw-bold mb-1" style={{ fontSize: '1.5rem', color: '#1e293b' }}>User Management</h2>
            <p className="text-muted small mb-0">Manage all registered users — Admin only</p>
          </div>
          <div className="d-flex align-items-center gap-2">
            <span className="au-total-badge">{filtered.length} user{filtered.length !== 1 ? 's' : ''}</span>
          </div>
        </div>

        {!admin && (
          <div className="alert alert-warning py-2 mb-3">Bạn cần quyền Admin để quản lý người dùng.</div>
        )}
        {error && <div className="alert alert-danger py-2 mb-3">{error}</div>}

        {/* Filters */}
        {admin && (
          <div className="au-filters mb-3 d-flex flex-wrap gap-2">
            <input
              type="text"
              className="form-control au-search"
              placeholder="Search by name or email…"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              style={{ maxWidth: 280 }}
            />
            <select
              className="form-select au-role-filter"
              value={filterRole}
              onChange={(e) => setFilterRole(e.target.value)}
              style={{ maxWidth: 160 }}
            >
              <option value="">All Roles</option>
              {ROLES.map((r) => <option key={r} value={r}>{ROLE_CONFIG[r].label}</option>)}
            </select>
          </div>
        )}

        {loading ? (
          <div className="text-center py-5 text-muted">Đang tải…</div>
        ) : (
          <div className="au-table-wrap shadow-sm">
            <div className="table-responsive">
              <table className="table au-table mb-0">
                <thead>
                  <tr>
                    <th scope="col">User</th>
                    <th scope="col">Email</th>
                    <th scope="col">Role</th>
                    <th scope="col">Status</th>
                    <th scope="col">Joined</th>
                    {admin && <th scope="col" className="text-center">Actions</th>}
                  </tr>
                </thead>
                <tbody>
                  {filtered.map((u) => (
                    <tr key={u.id}>
                      <td>
                        <div className="d-flex align-items-center gap-3">
                          {u.avatarUrl ? (
                            <img
                              src={u.avatarUrl}
                              alt={getFullName(u)}
                              className="au-avatar-img"
                            />
                          ) : (
                            <AvatarPlaceholder name={getFullName(u)} />
                          )}
                          <div>
                            <div className="fw-semibold" style={{ color: '#1e293b', fontSize: '0.9rem' }}>
                              {getFullName(u)}
                            </div>
                            <div className="text-muted small" style={{ fontSize: '0.78rem' }}>
                              ID: {String(u.id).slice(0, 8)}…
                            </div>
                          </div>
                        </div>
                      </td>
                      <td>
                        <div className="d-flex align-items-center gap-1 text-muted" style={{ fontSize: '0.87rem' }}>
                          <FiMail size={13} />
                          {u.email || '—'}
                        </div>
                      </td>
                      <td>
                        {admin && editingId === u.id ? (
                          <div className="d-flex align-items-center gap-1">
                            <select
                              className="form-select form-select-sm"
                              value={editRole}
                              onChange={(e) => setEditRole(e.target.value)}
                              style={{ width: 'auto', minWidth: 110 }}
                            >
                              {ROLES.map((r) => <option key={r} value={r}>{ROLE_CONFIG[r].label}</option>)}
                            </select>
                            <button
                              type="button"
                              className="btn btn-sm btn-primary-purple"
                              onClick={saveEditRole}
                              disabled={saving}
                              style={{ padding: '3px 10px' }}
                            >
                              {saving ? '…' : 'Lưu'}
                            </button>
                            <button
                              type="button"
                              className="btn btn-sm btn-secondary"
                              onClick={cancelEditRole}
                              style={{ padding: '3px 8px' }}
                            >
                              Hủy
                            </button>
                          </div>
                        ) : (
                          <RoleBadge role={u.role} />
                        )}
                      </td>
                      <td><StatusBadge active={u.isActive !== false} /></td>
                      <td style={{ color: '#64748b', fontSize: '0.85rem' }}>{formatDate(u.createdAt)}</td>
                      {admin && (
                        <td className="text-center">
                          <button
                            type="button"
                            className="au-btn-action me-1"
                            title="Change Role"
                            onClick={() => openEditRole(u)}
                            disabled={editingId === u.id || deletingId === u.id}
                          >
                            <FiEdit2 size={14} />
                          </button>
                          <button
                            type="button"
                            className="au-btn-action au-btn-action--del"
                            title="Delete User"
                            onClick={() => handleDelete(u.id)}
                            disabled={deletingId === u.id}
                          >
                            {deletingId === u.id ? '…' : <FiTrash2 size={14} />}
                          </button>
                        </td>
                      )}
                    </tr>
                  ))}
                  {filtered.length === 0 && (
                    <tr>
                      <td colSpan={admin ? 6 : 5} className="text-center text-muted py-4">
                        {users.length === 0 ? 'Chưa có người dùng nào.' : 'Không tìm thấy kết quả phù hợp.'}
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default AdminUserManagementPage;