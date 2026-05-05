import React, { useEffect, useState } from 'react';
import '../styles/lessonlist.css';
import { FiEdit2, FiTrash2, FiPlus, FiBookOpen, FiClock } from 'react-icons/fi';
import { getLessons, createLesson, updateLesson, deleteLesson } from '../services/lessonService';
import { getCourses } from '../services/courseService';
import { isAdmin, hasRole } from '../utils/roleUtils';

const LESSON_TYPES = ['VOCABULARY', 'GRAMMAR', 'SPEAKING', 'READING', 'LISTENING', 'WRITING'];
const EMPTY_FORM = { title: '', content: '', type: 'VOCABULARY', videoUrl: '', audioUrl: '', orderIndex: 0, durationMinutes: 0, isFree: false };

const typeLabel = (t) => t ? t.charAt(0) + t.slice(1).toLowerCase() : 'Vocabulary';

const typeColors = { VOCABULARY: '#6366f1', GRAMMAR: '#f59e0b', SPEAKING: '#0ea5e9', READING: '#10b981', LISTENING: '#8b5cf6', WRITING: '#ef4444' };

function TypeBadge({ type }) {
  const color = typeColors[type] || '#6366f1';
  return (
    <span className="ls-type-badge" style={{ color, backgroundColor: color + '18' }}>
      {typeLabel(type)}
    </span>
  );
}

function StatusBadge({ status }) {
  const cls = status === 'COMPLETED' ? 'ls-status--done'
    : status === 'IN_PROGRESS' ? 'ls-status--progress'
    : status === 'NOT_STARTED' ? 'ls-status--locked'
    : 'ls-status--pub';
  return <span className={`ls-status ${cls}`}>{status?.replace('_', ' ') || 'Unknown'}</span>;
}

const LessonList = () => {
  const [lessons, setLessons] = useState([]);
  const [coursesLoading, setCoursesLoading] = useState(true);
  const [lessonsLoading, setLessonsLoading] = useState(false);
  const [error, setError] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [editId, setEditId] = useState(null);
  const [form, setForm] = useState(EMPTY_FORM);
  const [courses, setCourses] = useState([]);
  const [selectedCourse, setSelectedCourse] = useState('');
  const [saving, setSaving] = useState(false);
  const canManage = isAdmin() || hasRole('TEACHER');
  const loading = coursesLoading || lessonsLoading;

  const fetchCourses = async () => {
    setCoursesLoading(true);
    setError('');
    try {
      const res = await getCourses();
      const raw = res.data?.content ?? res.data ?? [];
      const list = Array.isArray(raw) ? raw : [];
      setCourses(list);
      if (list.length > 0) setSelectedCourse((prev) => prev || list[0].id);
    } catch {
      setError('Không tải được danh sách khóa học.');
    } finally {
      setCoursesLoading(false);
    }
  };

  useEffect(() => {
    fetchCourses();
  }, []);

  useEffect(() => {
    if (!selectedCourse) {
      setLessons([]);
      return;
    }
    let cancelled = false;
    (async () => {
      setLessonsLoading(true);
      setError('');
      try {
        const res = await getLessons(selectedCourse);
        if (!cancelled) setLessons(res.data || []);
      } catch {
        if (!cancelled) setError('Không tải được danh sách bài học.');
      } finally {
        if (!cancelled) setLessonsLoading(false);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, [selectedCourse]);

  const openCreate = () => {
    setEditId(null);
    setForm(EMPTY_FORM);
    setShowModal(true);
  };

  const openEdit = (lesson) => {
    setEditId(lesson.id);
    setForm({
      title: lesson.title || '',
      content: lesson.content || '',
      type: lesson.type || 'VOCABULARY',
      videoUrl: lesson.videoUrl || '',
      audioUrl: lesson.audioUrl || '',
      orderIndex: lesson.orderIndex ?? 0,
      durationMinutes: lesson.durationMinutes ?? 0,
      isFree: lesson.isFree ?? false,
    });
    setShowModal(true);
  };

  const handleDelete = async (lessonId) => {
    if (!window.confirm('Xóa bài học này?')) return;
    try {
      await deleteLesson(selectedCourse, lessonId);
      setLessons((prev) => prev.filter((l) => l.id !== lessonId));
    } catch {
      alert('Xóa thất bại.');
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!form.title.trim()) { alert('Vui lòng nhập tiêu đề bài học.'); return; }
    setSaving(true);
    try {
      if (editId) {
        const res = await updateLesson(selectedCourse, editId, form);
        setLessons((prev) => prev.map((l) => l.id === editId ? res.data : l));
      } else {
        const res = await createLesson(selectedCourse, form);
        setLessons((prev) => [...prev, res.data]);
      }
      setShowModal(false);
    } catch (err) {
      alert(err.response?.status === 409 ? 'Đã tồn tại.' : (err.response?.data?.message || 'Lưu thất bại.'));
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="ls-page py-4 px-3">
      <div className="ls-inner mx-auto">
        <div className="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
          <div>
            <h2 className="fw-bold mb-1" style={{ fontSize: '1.5rem', color: '#1e293b' }}>Lessons</h2>
            <p className="text-muted small mb-0">Organize lessons within each course</p>
          </div>
          {canManage && selectedCourse && (
            <button type="button" className="btn btn-primary-purple px-4 d-flex align-items-center gap-2" onClick={openCreate}>
              <FiPlus size={16} /> New Lesson
            </button>
          )}
        </div>

        {canManage && (
          <div className="mb-3">
            <label className="form-label small fw-semibold">Course</label>
            <select className="form-select" style={{ maxWidth: 320 }} value={selectedCourse} onChange={(e) => setSelectedCourse(e.target.value)}>
              <option value="">Select course…</option>
              {courses.map((c) => <option key={c.id} value={c.id}>{c.title}</option>)}
            </select>
          </div>
        )}

        {error && <div className="alert alert-danger py-2">{error}</div>}

        {loading ? (
          <div className="text-center py-5 text-muted">
            {coursesLoading ? 'Đang tải khóa học…' : 'Đang tải bài học…'}
          </div>
        ) : (
          <div className="ls-card shadow-sm">
            <div className="table-responsive">
              <table className="table ls-table mb-0">
                <thead>
                  <tr>
                    <th scope="col">#</th>
                    <th scope="col">Lesson Title</th>
                    <th scope="col">Course</th>
                    <th scope="col">Type</th>
                    <th scope="col">Exercises</th>
                    <th scope="col">Duration</th>
                    <th scope="col">Status</th>
                    {canManage && <th scope="col" className="text-center">Actions</th>}
                  </tr>
                </thead>
                <tbody>
                  {lessons.map((lesson) => (
                    <tr key={lesson.id}>
                      <td style={{ color: '#94a3b8', fontWeight: 600, fontSize: '0.8rem' }}>#{lesson.orderIndex ?? 0}</td>
                      <td>
                        <div className="d-flex align-items-center gap-2">
                          <FiBookOpen size={16} style={{ color: '#6366f1', flexShrink: 0 }} />
                          <span className="fw-semibold" style={{ color: '#1e293b' }}>{lesson.title}</span>
                        </div>
                      </td>
                      <td style={{ color: '#64748b' }}>{courses.find((c) => c.id === selectedCourse)?.title || '—'}</td>
                      <td><TypeBadge type={lesson.type} /></td>
                      <td style={{ color: '#475569' }}>{lesson.totalExercises ?? 0}</td>
                      <td>
                        <div className="d-flex align-items-center gap-1" style={{ color: '#64748b' }}>
                          <FiClock size={13} />
                          {lesson.durationMinutes ?? 0} min
                        </div>
                      </td>
                      <td><StatusBadge status={lesson.progressStatus} /></td>
                      {canManage && (
                        <td className="text-center">
                          <button className="ll-btn-action me-1" onClick={() => openEdit(lesson)}><FiEdit2 size={14} /></button>
                          <button className="ll-btn-action" onClick={() => handleDelete(lesson.id)}><FiTrash2 size={14} /></button>
                        </td>
                      )}
                    </tr>
                  ))}
                  {lessons.length === 0 && (
                    <tr><td colSpan={canManage ? 8 : 7} className="text-center text-muted py-4">Chưa có bài học nào.</td></tr>
                  )}
                </tbody>
              </table>
            </div>
          </div>
        )}
      </div>

      {showModal && (
        <div className="modal-backdrop fade show d-flex align-items-center justify-content-center" style={{ background: 'rgba(0,0,0,0.5)', zIndex: 1050 }}>
          <div className="modal show d-block" tabIndex="-1">
            <div className="modal-dialog modal-lg">
              <div className="modal-content">
                <div className="modal-header">
                  <h5 className="modal-title">{editId ? 'Edit Lesson' : 'New Lesson'}</h5>
                  <button type="button" className="btn-close" aria-label="Đóng" onClick={() => setShowModal(false)} />
                </div>
                <form onSubmit={handleSubmit}>
                  <div className="modal-body">
                    <div className="row">
                      <div className="col-md-8 mb-2">
                        <label className="form-label small fw-semibold">Title *</label>
                        <input type="text" className="form-control" value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} maxLength={150} required />
                      </div>
                      <div className="col-md-4 mb-2">
                        <label className="form-label small fw-semibold">Type</label>
                        <select className="form-select" value={form.type} onChange={(e) => setForm({ ...form, type: e.target.value })}>
                          {LESSON_TYPES.map((t) => <option key={t} value={t}>{typeLabel(t)}</option>)}
                        </select>
                      </div>
                    </div>
                    <div className="mb-2">
                      <label className="form-label small fw-semibold">Content</label>
                      <textarea className="form-control" rows={4} value={form.content} onChange={(e) => setForm({ ...form, content: e.target.value })} />
                    </div>
                    <div className="row">
                      <div className="col-md-6 mb-2">
                        <label className="form-label small fw-semibold">Video URL</label>
                        <input type="url" className="form-control" value={form.videoUrl} onChange={(e) => setForm({ ...form, videoUrl: e.target.value })} />
                      </div>
                      <div className="col-md-6 mb-2">
                        <label className="form-label small fw-semibold">Audio URL</label>
                        <input type="url" className="form-control" value={form.audioUrl} onChange={(e) => setForm({ ...form, audioUrl: e.target.value })} />
                      </div>
                    </div>
                    <div className="row">
                      <div className="col-md-4 mb-2">
                        <label className="form-label small fw-semibold">Order Index</label>
                        <input type="number" className="form-control" value={form.orderIndex} onChange={(e) => setForm({ ...form, orderIndex: parseInt(e.target.value) || 0 })} min={0} />
                      </div>
                      <div className="col-md-4 mb-2">
                        <label className="form-label small fw-semibold">Duration (minutes)</label>
                        <input type="number" className="form-control" value={form.durationMinutes} onChange={(e) => setForm({ ...form, durationMinutes: parseInt(e.target.value) || 0 })} min={0} />
                      </div>
                      <div className="col-md-4 mb-2 d-flex align-items-end">
                        <div className="form-check">
                          <input type="checkbox" className="form-check-input" id="lessonFree" checked={form.isFree} onChange={(e) => setForm({ ...form, isFree: e.target.checked })} />
                          <label className="form-check-label" htmlFor="lessonFree">Free lesson</label>
                        </div>
                      </div>
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

export default LessonList;
