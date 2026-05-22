import React, { useEffect, useState } from 'react';
import '../styles/topiclist.css';
import { FiEdit2, FiTrash2, FiPlus, FiX } from 'react-icons/fi';
import { FaLayerGroup } from 'react-icons/fa6';
import { getTopics, createTopic, updateTopic, deleteTopic } from '../services/topicService';
import { isAdmin } from '../utils/roleUtils';


const EMPTY_FORM = { name: '', description: '', iconUrl: '', isActive: true };

function normalizeTopicList(payload) {
  if (payload == null) return [];
  if (Array.isArray(payload)) return payload;
  if (Array.isArray(payload.content)) return payload.content;
  if (Array.isArray(payload.data)) return payload.data;
  if (Array.isArray(payload.items)) return payload.items;
  if (Array.isArray(payload.topics)) return payload.topics;
  if (Array.isArray(payload.results)) return payload.results;
  return [];
}

function isDemoTopicId(id) {
  return id != null && String(id).startsWith('demo-');
}

function TopicList() {
  const admin = isAdmin();
  const [topics, setTopics] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [loadWarning, setLoadWarning] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [editId, setEditId] = useState(null);
  const [form, setForm] = useState(EMPTY_FORM);
  const [saving, setSaving] = useState(false);
  const [deletingId, setDeletingId] = useState(null);
  const [formErrors, setFormErrors] = useState({});

  const fetchTopics = async () => {
    setLoading(true);
    setError('');
    setLoadWarning('');
    try {
      const res = await getTopics();
      const list = normalizeTopicList(res.data);
      setTopics(list);
    } catch {
      setTopics([]);
      setLoadWarning('Không tải được danh sách từ máy chủ (mạng, proxy hoặc API).');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchTopics(); }, []);

  const openCreate = () => {
    setEditId(null);
    setForm(EMPTY_FORM);
    setFormErrors({});
    setShowModal(true);
  };

  const openEdit = (t) => {
    setEditId(t.id);
    setFormErrors({});
    setForm({
      name: t.name || '',
      description: t.description || '',
      iconUrl: t.iconUrl || '',
      isActive: t.isActive ?? true,
    });
    setShowModal(true);
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Xóa chủ đề này?')) return;
    if (isDemoTopicId(id)) {
      setTopics((prev) => prev.filter((t) => t.id !== id));
      return;
    }
    setDeletingId(id);
    try {
      await deleteTopic(id);
      setTopics((prev) => prev.filter((t) => t.id !== id));
    } catch (err) {
      const msg = err.response?.data?.message;
      alert(msg === 'Cannot delete topic that has courses'
        ? 'Không thể xóa chủ đề đang có khoá học.'
        : (msg || 'Xóa thất bại.'));
    } finally {
      setDeletingId(null);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!form.name.trim()) {
      setFormErrors({ name: 'Name không được để trống.' });
      return;
    }
    setFormErrors({});
    if (editId && isDemoTopicId(editId)) {
      setTopics((prev) =>
        prev.map((t) =>
          t.id === editId
            ? {
                ...t,
                ...form,
                orderIndex: t.orderIndex,
                updatedAt: new Date().toISOString(),
              }
            : t
        )
      );
      setShowModal(false);
      return;
    }
    setSaving(true);
    try {
      if (editId) {
        const res = await updateTopic(editId, form);
        setTopics((prev) => prev.map((t) => (t.id === editId ? res.data : t)));
      } else {
        const res = await createTopic(form);
        setTopics((prev) => [...prev, res.data]);
      }
      setShowModal(false);
    } catch (err) {
      alert(err.response?.status === 409 ? 'Đã tồn tại.' : (err.response?.data?.message || 'Lưu thất bại.'));
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="tl-page py-4 px-3">
      <div className="tl-inner mx-auto">
        <div className="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
          <div>
            <h2 className="fw-bold mb-1" style={{ fontSize: '1.5rem', color: '#1e293b' }}>Chủ đề</h2>
            <p className="text-muted small mb-0">Quản lý các chủ đề học tập</p>
          </div>
          {admin && (
            <button type="button" className="btn btn-primary-purple px-4 d-flex align-items-center gap-2" onClick={openCreate}>
              <FiPlus size={16} /> Thêm chủ đề
            </button>
          )}
        </div>

        {error && <div className="alert alert-danger py-2">{error}</div>}
        {loadWarning && (
          <div className="alert alert-warning py-2 mb-2" role="status">
            {loadWarning}
          </div>
        )}

        {loading ? (
          <div className="text-center py-5 text-muted">Đang tải…</div>
        ) : (
          <div className="tl-grid">
            {topics.map((t) => (
              <div key={t.id} className="tl-card shadow-sm">
                <div className="tl-card-body">
                  <div className="d-flex align-items-start justify-content-between mb-2">
                    <div className="tl-icon-wrap">
                      {t.iconUrl ? (
                        /^https?:\/\//i.test(t.iconUrl) ? (
                          <img src={t.iconUrl} alt={t.name} className="tl-icon-img" />
                        ) : (
                          <span className="tl-icon-emoji">{t.iconUrl}</span>
                        )
                      ) : (
                        <FaLayerGroup size={22} style={{ color: '#6366f1' }} />
                      )}
                    </div>
                    <div className="d-flex gap-2 flex-wrap">
                      <span className={`tl-status ${t.isActive ? 'tl-status--on' : 'tl-status--off'}`}>
                        {t.isActive ? 'Active' : 'Inactive'}
                      </span>
                      {admin && (
                        <div className="d-flex gap-1">
                          <button className="tl-btn-action" title="Edit" onClick={() => openEdit(t)}>
                            <FiEdit2 size={14} />
                          </button>
                          <button
                            className="tl-btn-action"
                            title="Delete"
                            onClick={() => handleDelete(t.id)}
                            disabled={deletingId === t.id}
                          >
                            <FiTrash2 size={14} />
                          </button>
                        </div>
                      )}
                    </div>
                  </div>
                  <h6 className="fw-bold mb-1" style={{ color: '#1e293b' }}>{t.name}</h6>
                  <p className="text-muted small mb-0" style={{ fontSize: '0.82rem' }}>
                    {t.description || 'Không có mô tả'}
                  </p>
                  {t.orderIndex != null && (
                    <span className="tl-order">Order: {t.orderIndex}</span>
                  )}
                </div>
              </div>
            ))}
            {topics.length === 0 && (
              <div className="text-center text-muted py-5 w-100">Chưa có chủ đề nào.</div>
            )}
          </div>
        )}
      </div>

      {showModal && (
        <div className="tl-modal-root" role="presentation">
          <button type="button" className="tl-modal-backdrop" aria-label="Đóng" onClick={() => setShowModal(false)} />
          <div className="tl-modal-panel" role="dialog" aria-modal="true">
            <div className="tl-modal-panel__header">
              <h5 className="tl-modal-panel__title">{editId ? 'Sửa chủ đề' : 'Thêm chủ đề'}</h5>
              <button type="button" className="tl-modal-panel__close" onClick={() => setShowModal(false)} aria-label="Đóng">
                <FiX size={22} />
              </button>
            </div>
            <form onSubmit={handleSubmit} noValidate>
              <div className="tl-modal-panel__body">
                <div className="mb-2">
                  <label className="form-label small fw-semibold">Name *</label>
                  <input type="text" className={`form-control${formErrors.name ? ' is-invalid' : ''}`} value={form.name}
                    onChange={(e) => setForm({ ...form, name: e.target.value })} maxLength={100} />
                  {formErrors.name && <div className="invalid-feedback">{formErrors.name}</div>}
                </div>
                <div className="mb-2">
                  <label className="form-label small fw-semibold">Description</label>
                  <textarea className="form-control" rows={3} value={form.description}
                    onChange={(e) => setForm({ ...form, description: e.target.value })} maxLength={500} />
                </div>
                <div className="mb-2">
                  <label className="form-label small fw-semibold">Icon URL</label>
                  <input type="text" className="form-control" value={form.iconUrl}
                    onChange={(e) => setForm({ ...form, iconUrl: e.target.value })} placeholder="https://…" />
                </div>
                <div className="form-check">
                  <input type="checkbox" className="form-check-input" id="topicActive"
                    checked={form.isActive}
                    onChange={(e) => setForm({ ...form, isActive: e.target.checked })} />
                  <label className="form-check-label" htmlFor="topicActive">Active</label>
                </div>
              </div>
              <div className="tl-modal-panel__footer">
                <button type="button" className="btn btn-secondary" onClick={() => setShowModal(false)}>Hủy</button>
                <button type="submit" className="btn btn-primary-purple" disabled={saving}>
                  {saving ? 'Đang lưu…' : 'Lưu'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}

export default TopicList;
