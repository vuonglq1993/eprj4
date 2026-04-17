import React, { useEffect, useState } from 'react';
import '../styles/subscriptionplansadmin.css';
import { FiEdit2, FiPlus, FiToggleLeft, FiToggleRight, FiX } from 'react-icons/fi';
import {
  getSubscriptionPlans,
  createSubscriptionPlan,
  updateSubscriptionPlan,
  toggleSubscriptionPlan,
  normalizeSubscriptionPlan,
  normalizePlansListResponse,
  sortPlansForDisplay,
} from '../services/subscriptionPlanService';
import { isAdmin } from '../utils/roleUtils';

const EMPTY_FORM = {
  name: '',
  description: '',
  price: '',
  currency: 'VND',
  durationDays: '30',
  features: '',
  isActive: true,
};

function formatPrice(p) {
  if (p == null) return '-';
  return new Intl.NumberFormat('vi-VN').format(p) + ' đ';
}

function SubscriptionPlansAdminPage() {
  const admin = isAdmin();
  const [plans, setPlans] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [editId, setEditId] = useState(null);
  const [form, setForm] = useState(EMPTY_FORM);
  const [saving, setSaving] = useState(false);
  const [togglingId, setTogglingId] = useState(null);

  const fetchPlans = async () => {
    setLoading(true);
    setError('');
    try {
      const res = await getSubscriptionPlans();
      const list = normalizePlansListResponse(res.data);
      setPlans(sortPlansForDisplay(list));
    } catch {
      setError('Không tải được danh sách gói subscription.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchPlans(); }, []);

  const openCreate = () => {
    setEditId(null);
    setForm(EMPTY_FORM);
    setShowModal(true);
  };

  const openEdit = (p) => {
    setEditId(p.id);
    setForm({
      name: p.name || '',
      description: p.description || '',
      price: p.price ?? '',
      currency: p.currency || 'VND',
      durationDays: String(p.durationDays ?? 30),
      features: (p.features || []).join('\n'),
      isActive: p.isActive ?? true,
    });
    setShowModal(true);
  };

  const handleToggle = async (id) => {
    setTogglingId(id);
    try {
      const res = await toggleSubscriptionPlan(id);
      const next = normalizeSubscriptionPlan(res.data);
      setPlans((prev) => sortPlansForDisplay(prev.map((p) => (p.id === id ? next : p))));
    } catch {
      alert('Thay đổi trạng thái thất bại.');
    } finally {
      setTogglingId(null);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!form.name.trim()) {
      alert('Vui lòng nhập tên gói.');
      return;
    }
    const features = form.features
      ? form.features.split('\n').map((f) => f.trim()).filter(Boolean)
      : [];
    const payload = {
      ...form,
      price: form.price ? Number(form.price) : 0,
      durationDays: Number(form.durationDays) || 30,
      features,
    };
    setSaving(true);
    try {
      if (editId) {
        const res = await updateSubscriptionPlan(editId, payload);
        const next = normalizeSubscriptionPlan(res.data);
        setPlans((prev) => sortPlansForDisplay(prev.map((p) => (p.id === editId ? next : p))));
      } else {
        const res = await createSubscriptionPlan(payload);
        const next = normalizeSubscriptionPlan(res.data);
        setPlans((prev) => sortPlansForDisplay([...prev, next]));
      }
      setShowModal(false);
    } catch (err) {
      alert(err.response?.data?.message || 'Lưu thất bại.');
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="sp-page py-4 px-3">
      <div className="sp-inner mx-auto">
        <div className="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
          <div>
            <h2 className="fw-bold mb-1" style={{ fontSize: '1.5rem', color: '#1e293b' }}>Subscription Plans</h2>
            <p className="text-muted small mb-0">Manage subscription packages — Admin only</p>
          </div>
          {admin && (
            <button type="button" className="btn btn-primary-purple px-4 d-flex align-items-center gap-2" onClick={openCreate}>
              <FiPlus size={16} /> New Plan
            </button>
          )}
        </div>

        {error && <div className="alert alert-danger py-2">{error}</div>}
        {!admin && (
          <div className="alert alert-warning py-2">Bạn cần quyền Admin để quản lý gói subscription.</div>
        )}

        {loading ? (
          <div className="text-center py-5 text-muted">Đang tải…</div>
        ) : (
          <div className="sp-grid">
            {plans.map((p) => (
              <div key={p.id} className={`sp-card shadow-sm ${!p.isActive ? 'sp-card--inactive' : ''}`}>
                <div className="sp-card-header">
                  <div>
                    <h5 className="fw-bold mb-1" style={{ color: '#1e293b' }}>{p.name}</h5>
                    <p className="text-muted small mb-0">{p.description}</p>
                  </div>
                  <div className="sp-header-right">
                    <span className={`sp-badge ${p.isActive ? 'sp-badge--on' : 'sp-badge--off'}`}>
                      {p.isActive ? 'Active' : 'Inactive'}
                    </span>
                    {admin && (
                      <button
                        type="button"
                        className="sp-toggle-btn"
                        title={p.isActive ? 'Deactivate' : 'Activate'}
                        onClick={() => handleToggle(p.id)}
                        disabled={togglingId === p.id}
                      >
                        {p.isActive ? <FiToggleRight size={22} style={{ color: '#10b981' }} /> : <FiToggleLeft size={22} style={{ color: '#94a3b8' }} />}
                      </button>
                    )}
                  </div>
                </div>

                <div className="sp-price-row">
                  <span className="sp-price">{formatPrice(p.price)}</span>
                  <span className="sp-duration">/ {p.durationDays} days</span>
                </div>

                {p.features && p.features.length > 0 && (
                  <ul className="sp-features">
                    {p.features.map((f, i) => (
                      <li key={i}>{f}</li>
                    ))}
                  </ul>
                )}

                {admin && (
                  <div className="sp-footer">
                    <button type="button" className="sp-edit-btn" onClick={() => openEdit(p)}>
                      <FiEdit2 size={13} /> Edit
                    </button>
                  </div>
                )}
              </div>
            ))}
            {plans.length === 0 && (
              <div className="text-center text-muted py-5 w-100">Chưa có gói subscription nào.</div>
            )}
          </div>
        )}
      </div>

      {showModal && (
        <div className="sp-modal-root" role="presentation">
          <button type="button" className="sp-modal-backdrop" aria-label="Đóng" onClick={() => setShowModal(false)} />
          <div className="sp-modal-panel" role="dialog" aria-modal="true">
            <div className="sp-modal-panel__header">
              <h5 className="sp-modal-panel__title">{editId ? 'Edit Plan' : 'New Plan'}</h5>
              <button type="button" className="sp-modal-panel__close" onClick={() => setShowModal(false)} aria-label="Đóng">
                <FiX size={22} />
              </button>
            </div>
            <form onSubmit={handleSubmit}>
              <div className="sp-modal-panel__body">
                <div className="mb-2">
                  <label className="form-label small fw-semibold">Plan Name *</label>
                  <input type="text" className="form-control" value={form.name}
                    onChange={(e) => setForm({ ...form, name: e.target.value })} maxLength={50} required />
                </div>
                <div className="mb-2">
                  <label className="form-label small fw-semibold">Description</label>
                  <textarea className="form-control" rows={2} value={form.description}
                    onChange={(e) => setForm({ ...form, description: e.target.value })} maxLength={200} />
                </div>
                <div className="row">
                  <div className="col-md-6 mb-2">
                    <label className="form-label small fw-semibold">Price (VND) *</label>
                    <input type="number" className="form-control" value={form.price}
                      onChange={(e) => setForm({ ...form, price: e.target.value })} min={0} required />
                  </div>
                  <div className="col-md-6 mb-2">
                    <label className="form-label small fw-semibold">Duration (days) *</label>
                    <input type="number" className="form-control" value={form.durationDays}
                      onChange={(e) => setForm({ ...form, durationDays: e.target.value })} min={1} required />
                  </div>
                </div>
                <div className="mb-2">
                  <label className="form-label small fw-semibold">Features (one per line)</label>
                  <textarea className="form-control" rows={4} value={form.features}
                    onChange={(e) => setForm({ ...form, features: e.target.value })}
                    placeholder="Unlimited courses&#10;Priority support&#10;Certificate" />
                </div>
                <div className="form-check">
                  <input type="checkbox" className="form-check-input" id="planActive"
                    checked={form.isActive}
                    onChange={(e) => setForm({ ...form, isActive: e.target.checked })} />
                  <label className="form-check-label" htmlFor="planActive">Active</label>
                </div>
              </div>
              <div className="sp-modal-panel__footer">
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

export default SubscriptionPlansAdminPage;
