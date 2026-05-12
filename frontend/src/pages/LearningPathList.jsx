import React, { useEffect, useState } from 'react';
import '../styles/learningpathlist.css';
import { FiEdit2, FiTrash2, FiPlus } from 'react-icons/fi';
import { FaRoute } from 'react-icons/fa6';
import {
  getLearningPaths,
  createLearningPath,
  updateLearningPath,
  togglePublishLearningPath,
  deleteLearningPath,
} from '../services/learningPathService';
import { getLanguages } from '../services/languageService';
import { getCourses } from '../services/courseService';
import { isAdmin } from '../utils/roleUtils';
import { DEMO_LEARNING_PATHS, DEMO_LANGUAGES_FOR_PATH } from '../data/learningPathDemo';


const EMPTY_FORM = {
  title: '',
  description: '',
  languageId: '',
  targetLevel: 'BEGINNER',
  estimatedDays: 0,
  goal: '',
  thumbnailUrl: '',
  isPublished: false,
  courseIds: [],
};

function levelLabel(l) {
  return l ? l.charAt(0) + l.slice(1).toLowerCase() : 'Beginner';
}
function getLevelClass(l) {
  const m = { BEGINNER: 'beginner', INTERMEDIATE: 'intermediate', ADVANCED: 'advanced' };
  return m[l] || 'beginner';
}

/** Chuẩn hoá nhiều kiểu JSON backend (Page, ApiResponse, mảng thuần) */
function normalizePathList(payload) {
  if (payload == null) return [];
  if (Array.isArray(payload)) return payload;
  if (Array.isArray(payload.content)) return payload.content;
  if (Array.isArray(payload.data)) return payload.data;
  if (Array.isArray(payload.items)) return payload.items;
  if (Array.isArray(payload.learningPaths)) return payload.learningPaths;
  if (Array.isArray(payload.results)) return payload.results;
  return [];
}

function normalizeLanguageList(payload) {
  if (payload == null) return [];
  if (Array.isArray(payload)) return payload;
  if (Array.isArray(payload.content)) return payload.content;
  if (Array.isArray(payload.data)) return payload.data;
  return [];
}

function normalizeCourses(payload) {
  if (payload == null) return [];
  if (Array.isArray(payload)) return payload;
  if (Array.isArray(payload.content)) return payload.content;
  if (Array.isArray(payload.data)) return payload.data;
  return [];
}

/** Lộ trình demo (offline) — không gọi API để tránh 403 */
function isDemoLearningPathId(id) {
  return id != null && String(id).startsWith('demo-');
}

const LearningPathList = () => {
  const [paths, setPaths] = useState([]);
  const [languages, setLanguages] = useState([]);
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [loadWarning, setLoadWarning] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [editId, setEditId] = useState(null);
  const [form, setForm] = useState(EMPTY_FORM);
  const [saving, setSaving] = useState(false);
  const [publishingId, setPublishingId] = useState(null);
  const [deletingId, setDeletingId] = useState(null);
  const [currentPage, setCurrentPage] = useState(0);
  const [totalPages, setTotalPages] = useState(0);
  const canManage = isAdmin();

  const PAGE_SIZE = 12;

  const fetchAll = async (page = 0) => {
    setLoading(true);
    setError('');
    setLoadWarning('');

    let pathList = [];
    let pathsFromApi = false;

    try {
      const pathsRes = await getLearningPaths({ page, size: PAGE_SIZE });
      const payload = pathsRes.data;
      pathList = normalizePathList(payload);
      if (payload && typeof payload.totalPages === 'number') {
        setTotalPages(payload.totalPages);
        setCurrentPage(payload.page ?? page);
      }
      pathsFromApi = true;
    } catch {
      pathList = [...DEMO_LEARNING_PATHS];
      setLoadWarning(
        'Không tải được danh sách từ máy chủ (mạng, proxy hoặc API chưa có). Đang hiển thị dữ liệu mẫu để xem giao diện.'
      );
    }

    setPaths(pathList);

    if (canManage) {
      try {
        const langRes = await getLanguages();
        let langs = normalizeLanguageList(langRes.data);
        if (!pathsFromApi && (!langs || langs.length === 0)) {
          langs = [...DEMO_LANGUAGES_FOR_PATH];
        }
        setLanguages(langs);
      } catch {
        setLanguages(pathsFromApi ? [] : [...DEMO_LANGUAGES_FOR_PATH]);
      }

      try {
        const courseRes = await getCourses({ size: 100 });
        setCourses(normalizeCourses(courseRes.data));
      } catch {
        setCourses([]);
      }
    }

    if (pathsFromApi && pathList.length === 0) {
      /* API thành công nhưng chưa có bản ghi — không báo lỗi */
    }

    setLoading(false);
  };

  useEffect(() => { fetchAll(currentPage); }, []);

  const openCreate = () => {
    setEditId(null);
    setForm(EMPTY_FORM);
    setShowModal(true);
  };

  const openEdit = (p) => {
    setEditId(p.id);
    setForm({
      title: p.title || '',
      description: p.description || '',
      languageId: p.languageId || p.language?.id || '',
      targetLevel: p.targetLevel || 'BEGINNER',
      estimatedDays: p.estimatedHours || p.estimatedDays || 0,
      goal: p.goal || '',
      thumbnailUrl: p.thumbnailUrl || '',
      isPublished: p.isPublished ?? false,
      courseIds: p.steps?.map((s) => s.courseId) || [],
    });
    setShowModal(true);
  };

  const handlePublish = async (id) => {
    if (isDemoLearningPathId(id)) {
      setPaths((prev) =>
        prev.map((p) => (p.id === id ? { ...p, isPublished: !p.isPublished, updatedAt: new Date().toISOString() } : p))
      );
      return;
    }
    setPublishingId(id);
    try {
      const res = await togglePublishLearningPath(id);
      setPaths((prev) => prev.map((p) => (p.id === id ? res.data : p)));
    } catch {
      alert('Xuất bản thất bại.');
    } finally {
      setPublishingId(null);
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Xóa lộ trình này?')) return;
    if (isDemoLearningPathId(id)) {
      setPaths((prev) => prev.filter((p) => p.id !== id));
      return;
    }
    setDeletingId(id);
    try {
      await deleteLearningPath(id);
      setPaths((prev) => prev.filter((p) => p.id !== id));
    } catch {
      alert('Xóa thất bại.');
    } finally {
      setDeletingId(null);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!form.title.trim() || !form.languageId) {
      alert('Vui lòng điền Title và chọn Language.');
      return;
    }
    if (form.courseIds.length === 0) {
      alert('Vui lòng chọn ít nhất một khóa học.');
      return;
    }
    if (editId && isDemoLearningPathId(editId)) {
      const lang = languages.find((l) => l.id === form.languageId);
      setPaths((prev) =>
        prev.map((p) =>
          p.id === editId
            ? {
                ...p,
                ...form,
                languageName: lang?.name || p.languageName,
                updatedAt: new Date().toISOString(),
              }
            : p
        )
      );
      setShowModal(false);
      return;
    }

    const payload = {
      title: form.title,
      description: form.description,
      languageId: form.languageId,
      targetLevel: form.targetLevel,
      estimatedHours: Number(form.estimatedDays),
      goal: form.goal,
      thumbnailUrl: form.thumbnailUrl,
      isPublished: form.isPublished,
      isOfficial: false,
      steps: form.courseIds.map((courseId) => ({ courseId, note: '', isRequired: true })),
    };

    setSaving(true);
    try {
      if (editId) {
        const res = await updateLearningPath(editId, payload);
        setPaths((prev) => prev.map((p) => (p.id === editId ? res.data : p)));
      } else {
        const res = await createLearningPath(payload);
        setPaths((prev) => [res.data, ...prev]);
      }
      setShowModal(false);
    } catch (err) {
      alert(err.response?.status === 409 ? 'Đã tồn tại.' : (err.response?.data?.message || 'Lưu thất bại.'));
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="lp-page py-4 px-3">
      <div className="lp-inner mx-auto">
        <div className="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
          <div>
            <h2 className="fw-bold mb-1" style={{ fontSize: '1.5rem', color: '#1e293b' }}>Learning Paths</h2>
            <p className="text-muted small mb-0">Structured learning roadmaps</p>
          </div>
          {canManage && (
            <button type="button" className="btn btn-primary-purple px-4 d-flex align-items-center gap-2" onClick={openCreate}>
              <FiPlus size={16} /> New Learning Path
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
          <div className="lp-grid">
            {paths.map((p) => (
                <div key={p.id} className="lp-card shadow-sm">
                  <div className="lp-card-img">
                    {p.thumbnailUrl ? (
                      <img src={p.thumbnailUrl} alt={p.title} />
                    ) : (
                      <div className="lp-card-thumb-placeholder">
                        <FaRoute size={36} style={{ color: '#94a3b8' }} />
                      </div>
                    )}
                    <span className={`lp-badge lp-badge--${getLevelClass(p.targetLevel)}`}>
                      {levelLabel(p.targetLevel)}
                    </span>
                  </div>
                  <div className="lp-card-body">
                    <h6 className="fw-bold mb-1" style={{ color: '#1e293b' }}>{p.title}</h6>
                    <p className="text-muted small mb-2" style={{ fontSize: '0.82rem' }}>
                      {p.description || 'Không có mô tả'}
                    </p>
                    <div className="d-flex flex-wrap gap-2 mb-3">
                      {p.languageName && <span className="lp-tag">{p.languageName}</span>}
                      <span className={`lp-status ${p.isPublished ? 'lp-status--pub' : 'lp-status--draft'}`}>
                        {p.isPublished ? 'Published' : 'Draft'}
                      </span>
                    </div>
                    <div className="d-flex align-items-center justify-content-between">
                      <span className="lp-meta">
                        {p.totalCourses ?? p.courses?.length ?? 0} courses
                      </span>
                      <div className="lp-actions">
                        {canManage && (
                          <>
                            <button type="button" className="lp-action-btn" title="Edit" onClick={() => openEdit(p)}>
                              <FiEdit2 size={13} /><span>Edit</span>
                            </button>
                            {!p.isPublished && (
                              <button
                                type="button"
                                className="lp-action-btn"
                                title="Publish"
                                onClick={() => handlePublish(p.id)}
                                disabled={publishingId === p.id}
                              >
                                {publishingId === p.id ? '…' : 'Pub'}
                              </button>
                            )}
                            <button
                              type="button"
                              className="lp-action-btn lp-action-btn--del"
                              title="Delete"
                              onClick={() => handleDelete(p.id)}
                              disabled={deletingId === p.id}
                            >
                              <FiTrash2 size={13} /><span>Del</span>
                            </button>
                          </>
                        )}
                      </div>
                    </div>
                  </div>
                </div>
            ))}
            {paths.length === 0 && (
              <div className="text-center text-muted py-5 w-100">Chưa có lộ trình nào.</div>
            )}
          </div>
        )}
      </div>

      {totalPages > 1 && (
        <nav className="d-flex justify-content-center mt-4" aria-label="Learning path pagination">
          <ul className="pagination mb-0">
            <li className={currentPage === 0 ? 'page-item disabled' : 'page-item'}>
              <button className="page-link" type="button" onClick={() => { setCurrentPage(0); fetchAll(0); }} disabled={currentPage === 0}>«</button>
            </li>
            <li className={currentPage === 0 ? 'page-item disabled' : 'page-item'}>
              <button className="page-link" type="button" onClick={() => { const p = currentPage - 1; setCurrentPage(p); fetchAll(p); }} disabled={currentPage === 0}>‹</button>
            </li>
            {Array.from({ length: totalPages }, (_, i) => (
              <li key={i} className={currentPage === i ? 'page-item active' : 'page-item'}>
                <button className="page-link" type="button" onClick={() => { setCurrentPage(i); fetchAll(i); }}>{i + 1}</button>
              </li>
            ))}
            <li className={currentPage >= totalPages - 1 ? 'page-item disabled' : 'page-item'}>
              <button className="page-link" type="button" onClick={() => { const n2 = currentPage + 1; setCurrentPage(n2); fetchAll(n2); }} disabled={currentPage >= totalPages - 1}>›</button>
            </li>
            <li className={currentPage >= totalPages - 1 ? 'page-item disabled' : 'page-item'}>
              <button className="page-link" type="button" onClick={() => { const last = totalPages - 1; setCurrentPage(last); fetchAll(last); }} disabled={currentPage >= totalPages - 1}>»</button>
            </li>
          </ul>
        </nav>
      )}

      {showModal && (
        <div className="modal-backdrop fade show d-flex align-items-center justify-content-center" style={{ background: 'rgba(0,0,0,0.5)', zIndex: 1050 }}>
          <div className="modal show d-block" tabIndex="-1">
            <div className="modal-dialog modal-lg">
              <div className="modal-content">
                <div className="modal-header">
                  <h5 className="modal-title">{editId ? 'Edit Learning Path' : 'New Learning Path'}</h5>
                </div>
                <form onSubmit={handleSubmit}>
                  <div className="modal-body">
                    <div className="mb-2">
                      <label className="form-label small fw-semibold">Title *</label>
                      <input type="text" className="form-control" value={form.title}
                        onChange={(e) => setForm({ ...form, title: e.target.value })} maxLength={150} required />
                    </div>
                    <div className="mb-2">
                      <label className="form-label small fw-semibold">Description</label>
                      <textarea className="form-control" rows={3} value={form.description}
                        onChange={(e) => setForm({ ...form, description: e.target.value })} maxLength={2000} />
                    </div>
                    <div className="row">
                      <div className="col-md-6 mb-2">
                        <label className="form-label small fw-semibold">Language *</label>
                        <select className="form-select" value={form.languageId}
                          onChange={(e) => setForm({ ...form, languageId: e.target.value })} required>
                          <option value="">Select…</option>
                          {languages.map((l) => <option key={l.id} value={l.id}>{l.name}</option>)}
                        </select>
                      </div>
                      <div className="col-md-6 mb-2">
                        <label className="form-label small fw-semibold">Target Level *</label>
                        <select className="form-select" value={form.targetLevel}
                          onChange={(e) => setForm({ ...form, targetLevel: e.target.value })}>
                          <option value="BEGINNER">Beginner</option>
                          <option value="INTERMEDIATE">Intermediate</option>
                          <option value="ADVANCED">Advanced</option>
                        </select>
                      </div>
                    </div>
                    <div className="row">
                      <div className="col-md-6 mb-2">
                        <label className="form-label small fw-semibold">Estimated Days</label>
                        <input type="number" className="form-control" value={form.estimatedDays}
                          onChange={(e) => setForm({ ...form, estimatedDays: Number(e.target.value) })}
                          min={0} max={365} />
                      </div>
                      <div className="col-md-6 mb-2">
                        <label className="form-label small fw-semibold">Goal</label>
                        <input type="text" className="form-control" value={form.goal}
                          onChange={(e) => setForm({ ...form, goal: e.target.value })} maxLength={300}
                          placeholder="e.g. Pass JLPT N5" />
                      </div>
                    </div>
                    <div className="mb-2">
                      <label className="form-label small fw-semibold">Thumbnail URL</label>
                      <input type="text" className="form-control" value={form.thumbnailUrl}
                        onChange={(e) => setForm({ ...form, thumbnailUrl: e.target.value })} placeholder="https://…" />
                    </div>
                    <div className="mb-2">
                      <label className="form-label small fw-semibold">Courses ({form.courseIds.length} selected)</label>
                      {courses.length === 0 ? (
                        <div className="form-control" style={{ color: '#64748b', fontSize: '0.875rem' }}>
                          {canManage ? 'Đang tải khóa học…' : 'Không có khóa học nào.'}
                        </div>
                      ) : (
                        <div className="border rounded p-2" style={{ maxHeight: 200, overflowY: 'auto' }}>
                          {courses.map((c) => {
                            const checked = form.courseIds.includes(c.id);
                            return (
                              <div key={c.id} className="form-check">
                                <input
                                  type="checkbox"
                                  className="form-check-input"
                                  id={`course-${c.id}`}
                                  checked={checked}
                                  onChange={(e) => {
                                    if (e.target.checked) {
                                      setForm((f) => ({ ...f, courseIds: [...f.courseIds, c.id] }));
                                    } else {
                                      setForm((f) => ({ ...f, courseIds: f.courseIds.filter((id) => id !== c.id) }));
                                    }
                                  }}
                                />
                                <label className="form-check-label" htmlFor={`course-${c.id}`}>
                                  {c.title}
                                </label>
                              </div>
                            );
                          })}
                        </div>
                      )}
                    </div>
                    <div className="form-check">
                      <input type="checkbox" className="form-check-input" id="lpPub"
                        checked={form.isPublished}
                        onChange={(e) => setForm({ ...form, isPublished: e.target.checked })} />
                      <label className="form-check-label" htmlFor="lpPub">Published immediately</label>
                    </div>
                  </div>
                  <div className="modal-footer">
                    <button type="button" className="btn btn-secondary" onClick={() => setShowModal(false)}>Hủy</button>
                    <button type="submit" className="btn btn-primary-purple" disabled={saving}>
                      {saving ? 'Đang lưu…' : 'Lưu'}
                    </button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default LearningPathList;
