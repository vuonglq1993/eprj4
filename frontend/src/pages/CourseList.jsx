import React, { useEffect, useState } from 'react';
import '../styles/courselist.css';
import { FiEdit2, FiTrash2, FiPlus } from 'react-icons/fi';
import { FaBook, FaStar } from 'react-icons/fa6';
import { getCourses, createCourse, updateCourse, publishCourse, deleteCourse } from '../services/courseService';
import { getLanguages } from '../services/languageService';
import { isAdmin, hasRole } from '../utils/roleUtils';
import { CourseThumbnailPlaceholder } from '../components/courses/CourseThumbnailPlaceholder';

const LEVELS = ['BEGINNER', 'INTERMEDIATE', 'ADVANCED'];

const EMPTY_FORM = { title: '', description: '', languageId: '', level: 'BEGINNER', thumbnailUrl: '', isPublished: false };

/** Độ dài tối đa cho URL ảnh — chuỗi base64 trong ô URL sẽ vượt và làm request lỗi. */
const THUMBNAIL_URL_MAX_LEN = 2048;

/**
 * Chỉ chấp nhận link http(s) ngắn; từ chối data: (base64) và URL quá dài.
 * @returns {{ ok: true, value: string } | { ok: false, message: string }}
 */
function validateThumbnailUrl(raw) {
  const t = (raw || '').trim();
  if (!t) return { ok: true, value: '' };
  if (/^data:/i.test(t)) {
    return {
      ok: false,
      message:
        'Không dùng ảnh dạng base64 (data:image/…) trong ô này — chuỗi quá dài, server thường báo lỗi. Hãy tải ảnh lên host (Imgur, Cloudinary, …) rồi dán link https://…',
    };
  }
  if (t.length > THUMBNAIL_URL_MAX_LEN) {
    return {
      ok: false,
      message: `Link ảnh quá dài (tối đa ${THUMBNAIL_URL_MAX_LEN} ký tự). Base64 trong ô URL không phù hợp — chỉ dùng link https ngắn.`,
    };
  }
  let parsed;
  try {
    parsed = new URL(t);
  } catch {
    return { ok: false, message: 'Thumbnail phải là URL hợp lệ, ví dụ https://example.com/image.jpg' };
  }
  if (parsed.protocol !== 'http:' && parsed.protocol !== 'https:') {
    return { ok: false, message: 'Chỉ chấp nhận link http hoặc https.' };
  }
  return { ok: true, value: t };
}

function formatSaveError(err) {
  const status = err.response?.status;
  const d = err.response?.data;
  let msg =
    (typeof d === 'string' && d.trim()) ||
    d?.message ||
    d?.error ||
    (Array.isArray(d?.errors) && d.errors.map((x) => x?.defaultMessage || x?.message).filter(Boolean).join(' '));
  if (!msg && status === 413) {
    msg = 'Dữ liệu gửi lên quá lớn (413). Thường do dán ảnh base64 vào URL — hãy dùng link https ngắn.';
  }
  if (!msg && status === 409) {
    msg = 'Đã tồn tại.';
  }
  if (!msg && !err.response) {
    msg = err.message || 'Không kết nối được server hoặc request bị chặn.';
  }
  return msg || 'Lưu thất bại.';
}


const PAGE_SIZE = 12;

const CourseList = () => {
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [editId, setEditId] = useState(null);
  const [form, setForm] = useState(EMPTY_FORM);
  const [languages, setLanguages] = useState([]);
  const [saving, setSaving] = useState(false);
  const [publishingId, setPublishingId] = useState(null);
  const [thumbnailFieldError, setThumbnailFieldError] = useState('');
  const [currentPage, setCurrentPage] = useState(0);
  const [totalPages, setTotalPages] = useState(0);
  const canManage = isAdmin() || hasRole('TEACHER');


  const fetchCourses = async (page = 0) => {
    setLoading(true);
    setError('');
    try {
      const res = await getCourses({ page, size: PAGE_SIZE });
      const payload = res.data;
      setCourses(payload.content || []);
      setCurrentPage(payload.page ?? page);
      setTotalPages(payload.totalPages ?? 0);
    } catch {
      setError('Không tải được danh sách khóa học.');
    } finally {
      setLoading(false);
    }
  };

 
  const fetchLanguages = async () => {
    try {
      const res = await getLanguages();
      setLanguages(res.data || []);
    } catch {}
  };

  useEffect(() => {
    fetchCourses(currentPage);
    if (canManage) fetchLanguages();
  }, []);

 
  const openCreate = () => {
    setEditId(null);
    setForm(EMPTY_FORM);
    setThumbnailFieldError('');
    setShowModal(true);
  };


  const openEdit = (course) => {
    setEditId(course.id);
    setForm({
      title: course.title || '',
      description: course.description || '',
      languageId: course.languageId || '',
      level: course.level || 'BEGINNER',
      thumbnailUrl: course.thumbnailUrl || '',
      isPublished: course.isPublished ?? false,
    });
    setThumbnailFieldError('');
    setShowModal(true);
  };

 
  const handlePublish = async (id) => {
    setPublishingId(id);
    try {
      const res = await publishCourse(id);
      setCourses((prev) => prev.map((c) => c.id === id ? res.data : c));
    } catch {
      alert('Xuất bản thất bại.');
    } finally {
      setPublishingId(null);
    }
  };

  
  const handleDelete = async (id) => {
    if (!window.confirm('Xóa khóa học này?')) return;
    try {
      await deleteCourse(id);
      setCourses((prev) => prev.filter((c) => c.id !== id));
    } catch {
      alert('Xóa thất bại.');
    }
  };

  
  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!form.title.trim() || !form.languageId) {
      alert('Vui lòng điền đầy đủ Title và chọn Language.');
      return;
    }
    const thumb = validateThumbnailUrl(form.thumbnailUrl);
    if (!thumb.ok) {
      setThumbnailFieldError(thumb.message);
      return;
    }
    setThumbnailFieldError('');
    const payload = { ...form, thumbnailUrl: thumb.value };
    setSaving(true);
    try {
      if (editId) {
        const res = await updateCourse(editId, payload);
        setCourses((prev) => prev.map((c) => c.id === editId ? res.data : c));
      } else {
        const res = await createCourse(payload);
        setCourses((prev) => [res.data, ...prev]);
      }
      setShowModal(false);
    } catch (err) {
      alert(formatSaveError(err));
    } finally {
      setSaving(false);
    }
  };


  const levelLabel = (l) => l ? l.charAt(0) + l.slice(1).toLowerCase() : 'Beginner';

  return (
    <div className="cl-page py-4 px-3">
      <div className="cl-inner mx-auto">
        <div className="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
          <div>
            <h2 className="fw-bold mb-1" style={{ fontSize: '1.5rem', color: '#1e293b' }}>Courses</h2>
            <p className="text-muted small mb-0">Manage learning courses and curricula</p>
          </div>
          {canManage && (
            <button type="button" className="btn btn-primary-purple px-4 d-flex align-items-center gap-2" onClick={openCreate}>
              <FiPlus size={16} /> New Course
            </button>
          )}
        </div>

        {error && <div className="alert alert-danger py-2">{error}</div>}

        {loading ? (
          <div className="text-center py-5 text-muted">Đang tải…</div>
        ) : (
          <>
            <div className="cl-grid">
              {courses.map((course) => (
                <div key={course.id} className="cl-card shadow-sm">
                  <div className="cl-card-img">
                    {course.thumbnailUrl ? (
                      <img src={course.thumbnailUrl} alt={course.title} />
                    ) : (
                      <CourseThumbnailPlaceholder />
                    )}
                  </div>
                  <div className="cl-card-body">
                    <div className="d-flex justify-content-between align-items-start mb-2">
                      <div>
                        <h6 className="fw-bold mb-1" style={{ color: '#1e293b', fontSize: '0.9rem' }}>{course.title}</h6>
                        <span className="text-muted small">{course.languageName}</span>
                      </div>
                      <span className={`cl-status ${course.isPublished ? 'cl-status--pub' : 'cl-status--draft'}`}>
                        {course.isPublished ? 'Published' : 'Draft'}
                      </span>
                    </div>
                    <div className="d-flex align-items-center justify-content-between mb-2">
                      <span className={`cl-badge cl-badge--${(course.level || 'BEGINNER').toLowerCase()}`}>
                        {levelLabel(course.level)}
                      </span>
                      <div className="cl-actions">
                        {canManage && (
                          <>
                            <button type="button" className="cl-action-btn" title="Edit" onClick={() => openEdit(course)}>
                              <FiEdit2 size={14} aria-hidden />
                              <span>Edit</span>
                            </button>
                            {!course.isPublished && (
                              <button
                                type="button"
                                className="cl-action-btn"
                                title="Publish"
                                onClick={() => handlePublish(course.id)}
                                disabled={publishingId === course.id}
                              >
                                <span className="cl-action-btn__emoji" aria-hidden>{publishingId === course.id ? '…' : '📢'}</span>
                                <span>Publish</span>
                              </button>
                            )}
                            <button type="button" className="cl-action-btn cl-action-btn--del" title="Delete" onClick={() => handleDelete(course.id)}>
                              <FiTrash2 size={14} aria-hidden />
                              <span>Delete</span>
                            </button>
                          </>
                        )}
                      </div>
                    </div>
                    <div className="d-flex align-items-center justify-content-between">
                      <span className="cl-meta">
                        <FaBook size={13} className="me-1" style={{ color: '#6366f1' }} />
                        {course.totalLessons ?? 0} lessons
                      </span>
                      {course.rating != null && (
                        <div className="d-flex align-items-center gap-1">
                          <FaStar size={12} style={{ color: '#f59e0b' }} />
                          <span style={{ fontSize: '0.8rem', fontWeight: 600, color: '#475569' }}>{course.rating}</span>
                        </div>
                      )}
                    </div>
                  </div>
                </div>
              ))}
              {courses.length === 0 && (
                <div className="text-center text-muted py-5 w-100">Chưa có khóa học nào.</div>
              )}
            </div>
            {totalPages > 1 && (
              <nav className="d-flex justify-content-center mt-4" aria-label="Course pagination">
                <ul className="pagination mb-0">
                  <li className={currentPage === 0 ? 'page-item disabled' : 'page-item'}>
                    <button className="page-link" type="button" onClick={() => { setCurrentPage(0); fetchCourses(0); }} disabled={currentPage === 0}>«</button>
                  </li>
                  <li className={currentPage === 0 ? 'page-item disabled' : 'page-item'}>
                    <button className="page-link" type="button" onClick={() => { const p = currentPage - 1; setCurrentPage(p); fetchCourses(p); }} disabled={currentPage === 0}>‹</button>
                  </li>
                  {Array.from({ length: totalPages }, (_, i) => (
                    <li key={i} className={currentPage === i ? 'page-item active' : 'page-item'}>
                      <button className="page-link" type="button" onClick={() => { setCurrentPage(i); fetchCourses(i); }}>{i + 1}</button>
                    </li>
                  ))}
                  <li className={currentPage >= totalPages - 1 ? 'page-item disabled' : 'page-item'}>
                    <button className="page-link" type="button" onClick={() => { const n2 = currentPage + 1; setCurrentPage(n2); fetchCourses(n2); }} disabled={currentPage >= totalPages - 1}>›</button>
                  </li>
                  <li className={currentPage >= totalPages - 1 ? 'page-item disabled' : 'page-item'}>
                    <button className="page-link" type="button" onClick={() => { const last = totalPages - 1; setCurrentPage(last); fetchCourses(last); }} disabled={currentPage >= totalPages - 1}>»</button>
                  </li>
                </ul>
              </nav>
            )}
          </>
        )}
      </div>

      {showModal && (
        <div className="modal-backdrop fade show d-flex align-items-center justify-content-center" style={{ background: 'rgba(0,0,0,0.5)', zIndex: 1050 }}>
          <div className="modal show d-block" tabIndex="-1">
            <div className="modal-dialog modal-lg">
              <div className="modal-content">
                <div className="modal-header">
                  <h5 className="modal-title">{editId ? 'Edit Course' : 'New Course'}</h5>
                </div>
                <form onSubmit={handleSubmit}>
                  <div className="modal-body">
                    <div className="row">
                      <div className="col-md-8 mb-2">
                        <label className="form-label small fw-semibold">Title *</label>
                        <input type="text" className="form-control" value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} maxLength={150} required />
                      </div>
                      <div className="col-md-4 mb-2">
                        <label className="form-label small fw-semibold">Language *</label>
                        <select className="form-select" value={form.languageId} onChange={(e) => setForm({ ...form, languageId: e.target.value })} required>
                          <option value="">Select…</option>
                          {languages.map((l) => <option key={l.id} value={l.id}>{l.name}</option>)}
                        </select>
                      </div>
                    </div>
                    <div className="mb-2">
                      <label className="form-label small fw-semibold">Description</label>
                      <textarea className="form-control" rows={3} value={form.description} onChange={(e) => setForm({ ...form, description: e.target.value })} maxLength={5000} />
                    </div>
                    <div className="row">
                      <div className="col-md-6 mb-2">
                        <label className="form-label small fw-semibold">Level *</label>
                        <select className="form-select" value={form.level} onChange={(e) => setForm({ ...form, level: e.target.value })}>
                          {LEVELS.map((l) => <option key={l} value={l}>{levelLabel(l)}</option>)}
                        </select>
                      </div>
                      <div className="col-md-6 mb-2">
                        <label className="form-label small fw-semibold">Thumbnail URL</label>
                        <input
                          type="text"
                          inputMode="url"
                          autoComplete="off"
                          className={`form-control ${thumbnailFieldError ? 'is-invalid' : ''}`}
                          value={form.thumbnailUrl}
                          onChange={(e) => {
                            setThumbnailFieldError('');
                            setForm({ ...form, thumbnailUrl: e.target.value });
                          }}
                          placeholder="https://…"
                        />
                        {thumbnailFieldError ? (
                          <div className="invalid-feedback d-block">{thumbnailFieldError}</div>
                        ) : (
                          <small className="text-muted">
                            Chỉ dán link ảnh công khai (https). Không dán ảnh base64 (data:image/…) — sẽ quá dài và lỗi khi lưu.
                          </small>
                        )}
                      </div>
                    </div>
                    <div className="form-check">
                      <input type="checkbox" className="form-check-input" id="coursePub" checked={form.isPublished} onChange={(e) => setForm({ ...form, isPublished: e.target.checked })} />
                      <label className="form-check-label" htmlFor="coursePub">Published immediately</label>
                    </div>
                  </div>
                  <div className="modal-footer">
                    <button type="button" className="btn btn-secondary" onClick={() => setShowModal(false)}>Hủy</button>
                    <button type="submit" className="btn btn-primary-purple" disabled={saving}>{saving ? 'Đang lưu…' : 'Lưu'}</button>
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

export default CourseList;
