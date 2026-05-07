import React, { useEffect, useState } from 'react';
import '../styles/languagelist.css';
import { FiEdit2, FiTrash2, FiPlus, FiX } from 'react-icons/fi';
import { FaGlobe } from 'react-icons/fa6';
import { getLanguages, createLanguage, updateLanguage, deleteLanguage } from '../services/languageService';
import { useAuth } from '../contexts/AuthContext';
import { getApiErrorMessage } from '../utils/apiError';

const EMPTY_FORM = { code: '', name: '', nativeName: '', flag: '', isActive: true };

function StatusDot({ status }) {
  return (
    <span className={`ll-status-dot ${status === 'Active' ? 'll-status-dot--on' : 'll-status-dot--off'}`}>
      {status}
    </span>
  );
}

function LanguageList() {
  const { user } = useAuth();
  const admin = user?.role === 'ADMIN';
  const [languages, setLanguages] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [editId, setEditId] = useState(null);
  const [form, setForm] = useState(EMPTY_FORM);
  const [saving, setSaving] = useState(false);
  const [deletingId, setDeletingId] = useState(null);

  const fetchLanguages = async () => {
    setLoading(true);
    setError('');
    try {
      const res = await getLanguages();
      setLanguages(res.data || []);
    } catch (err) {
      setError('Không tải được danh sách ngôn ngữ.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchLanguages(); }, []);

  const openCreate = () => {
    setEditId(null);
    setForm(EMPTY_FORM);
    setShowModal(true);
  };

  const openEdit = (lang) => {
    setEditId(lang.id);
    setForm({
      code: lang.code || '',
      name: lang.name || '',
      nativeName: lang.nativeName || '',
      flag: lang.flag || '',
      isActive: lang.isActive ?? true,
    });
    setShowModal(true);
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Xóa ngôn ngữ này?')) return;
    setDeletingId(id);
    try {
      await deleteLanguage(id);
      setLanguages((prev) => prev.filter((l) => l.id !== id));
    } catch {
      alert('Xóa thất bại.');
    } finally {
      setDeletingId(null);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!form.code.trim() || !form.name.trim() || !form.nativeName.trim()) {
      alert('Vui lòng điền đầy đủ Code, Name, Native Name.');
      return;
    }
    setSaving(true);
    try {
      if (editId) {
        const res = await updateLanguage(editId, form);
        setLanguages((prev) => prev.map((l) => (l.id === editId ? res.data : l)));
      } else {
        const res = await createLanguage(form);
        setLanguages((prev) => [...prev, res.data]);
      }
      setShowModal(false);
    } catch (err) {
      alert(err.response?.status === 409 ? 'Đã tồn tại.' : (getApiErrorMessage(err) || 'Lưu thất bại.'));
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="ll-page py-4 px-3">
      <div className="ll-inner mx-auto">
        <div className="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
          <div>
            <h2 className="fw-bold mb-1" style={{ fontSize: '1.5rem', color: '#1e293b' }}>Languages</h2>
            <p className="text-muted small mb-0">Manage available learning languages</p>
          </div>
          {admin && (
            <button type="button" className="btn btn-primary-purple px-4 d-flex align-items-center gap-2" onClick={openCreate}>
              <FiPlus size={16} /> Add Language
            </button>
          )}
        </div>

        {error && <div className="alert alert-danger py-2">{error}</div>}

        {loading ? (
          <div className="text-center py-5 text-muted">Đang tải…</div>
        ) : (
          <div className="ll-card shadow-sm">
            <div className="table-responsive">
              <table className="table ll-table mb-0">
                <thead>
                  <tr>
                    <th scope="col">Language</th>
                    <th scope="col">Native Name</th>
                    <th scope="col">Code</th>
                    <th scope="col">Flag</th>
                    <th scope="col">Status</th>
                    <th scope="col">Courses</th>
                    {admin && <th scope="col" className="text-center">Actions</th>}
                  </tr>
                </thead>
                <tbody>
                  {languages.map((lang) => (
                    <tr key={lang.id}>
                      <td>
                        <div className="d-flex align-items-center gap-3">
                          <div className="ll-lang-icon" style={{ backgroundColor: (lang.flagColor || '#6366f1') + '18' }}>
                            <FaGlobe size={18} style={{ color: lang.flagColor || '#6366f1' }} />
                          </div>
                          <span className="fw-semibold" style={{ color: '#1e293b' }}>{lang.name}</span>
                        </div>
                      </td>
                      <td style={{ color: '#64748b' }}>{lang.nativeName}</td>
                      <td><span className="ll-code">{lang.code}</span></td>
                      <td style={{ fontSize: '1.2rem' }}>{lang.flag}</td>
                      <td><StatusDot status={lang.isActive ? 'Active' : 'Inactive'} /></td>
                      <td style={{ color: '#475569', fontWeight: 500 }}>{lang.totalPublishedCourses ?? 0}</td>
                      {admin && (
                        <td className="text-center">
                          <button className="ll-btn-action me-1" title="Edit" onClick={() => openEdit(lang)}><FiEdit2 size={14} /></button>
                          <button className="ll-btn-action" title="Delete" onClick={() => handleDelete(lang.id)} disabled={deletingId === lang.id}><FiTrash2 size={14} /></button>
                        </td>
                      )}
                    </tr>
                  ))}
                  {languages.length === 0 && (
                    <tr><td colSpan={admin ? 7 : 6} className="text-center text-muted py-4">Chưa có ngôn ngữ nào.</td></tr>
                  )}
                </tbody>
              </table>
            </div>
          </div>
        )}
      </div>

      {showModal && (
        <div className="ll-modal-root" role="presentation">
          <button
            type="button"
            className="ll-modal-backdrop"
            aria-label="Đóng"
            onClick={() => setShowModal(false)}
          />
          <div className="ll-modal-panel" role="dialog" aria-modal="true" aria-labelledby="ll-modal-title">
            <div className="ll-modal-panel__header">
              <h5 id="ll-modal-title" className="ll-modal-panel__title">{editId ? 'Edit Language' : 'Add Language'}</h5>
              <button type="button" className="ll-modal-panel__close" onClick={() => setShowModal(false)} aria-label="Đóng">
                <FiX size={22} />
              </button>
            </div>
            <form onSubmit={handleSubmit}>
              <div className="ll-modal-panel__body">
                <div className="mb-2">
                  <label className="form-label small fw-semibold">
                    Code (e.g. EN) {!editId && ' *'}
                  </label>
                  <input
                    type="text"
                    className="form-control"
                    value={form.code}
                    onChange={(e) => setForm({ ...form, code: e.target.value.toLowerCase() })}
                    maxLength={10}
                    required
                    readOnly={!!editId}
                    style={editId ? { backgroundColor: '#f1f5f9', cursor: 'not-allowed', color: '#64748b' } : {}}
                    placeholder={!editId ? 'EN' : ''}
                  />
                  {editId && <small className="form-text text-muted">Code cannot be changed after creation.</small>}
                </div>
                <div className="mb-2">
                  <label className="form-label small fw-semibold">Name *</label>
                  <input type="text" className="form-control" value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} maxLength={100} required />
                </div>
                <div className="mb-2">
                  <label className="form-label small fw-semibold">Native Name *</label>
                  <input type="text" className="form-control" value={form.nativeName} onChange={(e) => setForm({ ...form, nativeName: e.target.value })} maxLength={100} required />
                </div>
                <div className="mb-2">
                  <label className="form-label small fw-semibold">Flag (country code, viết HOA)</label>
                  <input type="text" className="form-control" value={form.flag} onChange={(e) => setForm({ ...form, flag: e.target.value.toUpperCase() })} maxLength={20} placeholder="US" />
                </div>
                <div className="form-check">
                  <input type="checkbox" className="form-check-input" id="langActive" checked={form.isActive} onChange={(e) => setForm({ ...form, isActive: e.target.checked })} />
                  <label className="form-check-label" htmlFor="langActive">Active</label>
                </div>
              </div>
              <div className="ll-modal-panel__footer">
                <button type="button" className="btn btn-secondary" onClick={() => setShowModal(false)}>Hủy</button>
                <button type="submit" className="btn btn-primary-purple" disabled={saving}>{saving ? 'Đang lưu…' : 'Lưu'}</button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}

export default LanguageList;
