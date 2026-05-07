import React, { useEffect, useState } from 'react';
import '../styles/exerciselist.css';
import { FiEdit2, FiTrash2, FiPlus, FiX, FiTarget } from 'react-icons/fi';
import { getExercises, createExercise, updateExercise, deleteExercise } from '../services/exerciseService';
import { getCourses } from '../services/courseService';
import { getLessons } from '../services/lessonService';
import { isAdmin } from '../utils/roleUtils';
import CourseCombobox from '../components/common/CourseCombobox';

const EXERCISE_TYPES = [
  'MULTIPLE_CHOICE',
  'FILL_IN_BLANK',
  'LISTENING_CHOICE',
  'SPEAKING',
  'TRANSLATION',
  'MATCHING',
  'DRAG_DROP',
];

const EMPTY_FORM = {
  title: '',
  type: 'MULTIPLE_CHOICE',
  questionData: '',
  orderIndex: 0,
  points: 10,
  timeLimitSeconds: 0,
};

const typeLabel = (t) => {
  const map = {
    MULTIPLE_CHOICE: 'Multiple Choice',
    FILL_IN_BLANK: 'Fill in Blank',
    LISTENING_CHOICE: 'Listening Choice',
    SPEAKING: 'Speaking',
    TRANSLATION: 'Translation',
    MATCHING: 'Matching',
    DRAG_DROP: 'Drag & Drop',
  };
  return map[t] || t || '—';
};

const typeColors = {
  MULTIPLE_CHOICE: '#6366f1',
  FILL_IN_BLANK: '#f59e0b',
  LISTENING_CHOICE: '#0ea5e9',
  SPEAKING: '#10b981',
  TRANSLATION: '#8b5cf6',
  MATCHING: '#ec4899',
  DRAG_DROP: '#ef4444',
};

function TypeBadge({ type }) {
  const color = typeColors[type] || '#6366f1';
  return (
    <span className="ex-type-badge" style={{ color, backgroundColor: color + '18' }}>
      {typeLabel(type)}
    </span>
  );
}

function LessonCombobox({ courseId, value, onChange, disabled }) {
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState('');
  const [options, setOptions] = useState([]);
  const [loading, setLoading] = useState(false);
  const [selectedLabel, setSelectedLabel] = useState('');
  const wrapperRef = React.useRef(null);

  useEffect(() => {
    if (!courseId) { setOptions([]); setSelectedLabel(''); return; }
    if (!value) { setSelectedLabel(''); return; }
    const match = options.find((o) => o.id === value);
    if (match) { setSelectedLabel(match.title); return; }
    (async () => {
      try {
        const res = await getLessons(courseId);
        const list = res.data?.content ?? res.data ?? [];
        const found = list.find((l) => l.id === value);
        if (found) setSelectedLabel(found.title);
      } catch {}
    })();
  }, [value, courseId]);

  useEffect(() => {
    if (!open || !courseId) return;
    let cancelled = false;
    (async () => {
      setLoading(true);
      try {
        const res = await getLessons(courseId);
        if (!cancelled) setOptions(res.data?.content ?? res.data ?? []);
      } catch {
        if (!cancelled) setOptions([]);
      } finally {
        if (!cancelled) setLoading(false);
      }
    })();
    return () => { cancelled = true; };
  }, [query, open, courseId]);

  useEffect(() => {
    function handler(e) {
      if (wrapperRef.current && !wrapperRef.current.contains(e.target)) setOpen(false);
    }
    if (open) document.addEventListener('mousedown', handler);
    return () => document.removeEventListener('mousedown', handler);
  }, [open]);

  const handleSelect = (lesson) => {
    onChange(lesson.id);
    setQuery('');
    setOpen(false);
  };

  const displayed = options.filter((o) =>
    o.title?.toLowerCase().includes(query.toLowerCase())
  );

  return (
    <div className="course-combobox lesson-combobox" ref={wrapperRef}>
      <div
        className={`course-combobox__control ${disabled ? 'disabled' : ''}`}
        onClick={() => !disabled && courseId && setOpen((v) => !v)}
        role="combobox"
        aria-expanded={open}
        aria-haspopup="listbox"
        aria-disabled={disabled}
      >
        <span className={`course-combobox__selected-text ${!selectedLabel ? 'placeholder' : ''}`}>
          {selectedLabel || (courseId ? 'Select lesson…' : 'Select course first')}
        </span>
        <div className="course-combobox__actions">
          {value && !disabled && (
            <span
              role="button"
              className="course-combobox__clear"
              onClick={(e) => { e.stopPropagation(); onChange(''); setSelectedLabel(''); setQuery(''); setOptions([]); }}
              aria-label="Clear"
            >
              <FiX size={14} />
            </span>
          )}
          <span className="course-combobox__arrow">
            {open ? (
              <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M4 10l4-4 4 4" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/></svg>
            ) : (
              <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M4 6l4 4 4-4" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/></svg>
            )}
          </span>
        </div>
      </div>

      {open && (
        <div className="course-combobox__dropdown" role="listbox">
          <div className="course-combobox__search-wrapper">
            <svg className="course-combobox__search-icon" width="15" height="15" viewBox="0 0 16 16" fill="none">
              <circle cx="7" cy="7" r="4.5" stroke="currentColor" strokeWidth="1.5"/>
              <path d="M10.5 10.5L14 14" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
            </svg>
            <input
              className="course-combobox__search"
              type="text"
              placeholder="Search lessons…"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              autoFocus
              onClick={(e) => e.stopPropagation()}
            />
          </div>
          <div className="course-combobox__options">
            {loading ? (
              <div className="course-combobox__message">Đang tải…</div>
            ) : displayed.length === 0 ? (
              <div className="course-combobox__message">Không tìm thấy bài học.</div>
            ) : (
              displayed.map((lesson) => (
                <div
                  key={lesson.id}
                  className={`course-combobox__option ${lesson.id === value ? 'selected' : ''}`}
                  role="option"
                  aria-selected={lesson.id === value}
                  onClick={() => handleSelect(lesson)}
                >
                  <span className="course-combobox__option-title">{lesson.title}</span>
                  <span className="course-combobox__option-meta">{lesson.type}</span>
                </div>
              ))
            )}
          </div>
        </div>
      )}
    </div>
  );
}

const ExerciseList = () => {
  const [exercises, setExercises] = useState([]);
  const [lessonsLoading, setLessonsLoading] = useState(false);
  const [error, setError] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [editId, setEditId] = useState(null);
  const [form, setForm] = useState(EMPTY_FORM);
  const [selectedCourse, setSelectedCourse] = useState('');
  const [selectedLesson, setSelectedLesson] = useState('');
  const [saving, setSaving] = useState(false);
  const [deletingId, setDeletingId] = useState(null);
  const canManage = isAdmin();
  const loading = lessonsLoading;

  useEffect(() => {
    if (!selectedCourse || !selectedLesson) { setExercises([]); return; }
    let cancelled = false;
    (async () => {
      setLessonsLoading(true);
      setError('');
      try {
        const res = await getExercises(selectedCourse, selectedLesson);
        if (!cancelled) setExercises(res.data || []);
      } catch {
        if (!cancelled) setError('Không tải được danh sách bài tập.');
      } finally {
        if (!cancelled) setLessonsLoading(false);
      }
    })();
    return () => { cancelled = true; };
  }, [selectedCourse, selectedLesson]);

  const openCreate = () => {
    setEditId(null);
    setForm(EMPTY_FORM);
    setShowModal(true);
  };

  const openEdit = (ex) => {
    setEditId(ex.id);
    setForm({
      title: ex.title || '',
      type: ex.type || 'MULTIPLE_CHOICE',
      questionData: typeof ex.questionData === 'string' ? ex.questionData : JSON.stringify(ex.questionData || {}),
      orderIndex: ex.orderIndex ?? 0,
      points: ex.points ?? 10,
      timeLimitSeconds: ex.timeLimitSeconds ?? 0,
    });
    setShowModal(true);
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Xóa bài tập này?')) return;
    setDeletingId(id);
    try {
      await deleteExercise(selectedCourse, selectedLesson, id);
      setExercises((prev) => prev.filter((e) => e.id !== id));
    } catch {
      alert('Xóa thất bại.');
    } finally {
      setDeletingId(null);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!form.title.trim()) { alert('Vui lòng nhập tiêu đề bài tập.'); return; }
    setSaving(true);
    try {
      let parsedData = {};
      if (form.questionData.trim()) {
        try { parsedData = JSON.parse(form.questionData); } catch { alert('questionData phải là JSON hợp lệ.'); setSaving(false); return; }
      }
      const payload = { ...form, questionData: parsedData };
      if (editId) {
        const res = await updateExercise(selectedCourse, selectedLesson, editId, payload);
        setExercises((prev) => prev.map((e) => e.id === editId ? res.data : e));
      } else {
        const res = await createExercise(selectedCourse, selectedLesson, payload);
        setExercises((prev) => [...prev, res.data]);
      }
      setShowModal(false);
    } catch (err) {
      alert(err.response?.status === 409 ? 'Đã tồn tại.' : (err.response?.data?.message || 'Lưu thất bại.'));
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="ex-page py-4 px-3">
      <div className="ex-inner mx-auto">
        <div className="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
          <div>
            <h2 className="fw-bold mb-1" style={{ fontSize: '1.5rem', color: '#1e293b' }}>Exercises</h2>
            <p className="text-muted small mb-0">Manage exercises within each lesson</p>
          </div>
          {canManage && selectedLesson && (
            <button type="button" className="btn btn-primary-purple px-4 d-flex align-items-center gap-2" onClick={openCreate}>
              <FiPlus size={16} /> New Exercise
            </button>
          )}
        </div>

        {canManage && (
          <div className="ex-filters mb-3">
            <div className="ex-filter-group">
              <label className="form-label small fw-semibold">Course</label>
              <CourseCombobox value={selectedCourse} onChange={(id) => { setSelectedCourse(id); setSelectedLesson(''); setExercises([]); }} />
            </div>
            <div className="ex-filter-group">
              <label className="form-label small fw-semibold">Lesson</label>
              <LessonCombobox courseId={selectedCourse} value={selectedLesson} onChange={setSelectedLesson} />
            </div>
          </div>
        )}

        {error && <div className="alert alert-danger py-2">{error}</div>}

        {!selectedCourse && !selectedLesson && !canManage && (
          <div className="ex-empty-state">
            <FiTarget size={40} style={{ color: '#cbd5e1' }} />
            <p>Select a course and lesson above to view exercises.</p>
          </div>
        )}

        {(!selectedLesson && selectedCourse && canManage) && (
          <div className="ex-empty-state">
            <FiTarget size={40} style={{ color: '#cbd5e1' }} />
            <p>Select a lesson to view its exercises.</p>
          </div>
        )}

        {loading ? (
          <div className="text-center py-5 text-muted">Đang tải bài tập…</div>
        ) : (
          selectedLesson && (
            <div className="ex-card shadow-sm">
              <div className="table-responsive">
                <table className="table ex-table mb-0">
                  <thead>
                    <tr>
                      <th scope="col">#</th>
                      <th scope="col">Title</th>
                      <th scope="col">Type</th>
                      <th scope="col">Points</th>
                      <th scope="col">Time Limit</th>
                      {canManage && <th scope="col" className="text-center">Actions</th>}
                    </tr>
                  </thead>
                  <tbody>
                    {exercises.map((ex) => (
                      <tr key={ex.id}>
                        <td style={{ color: '#94a3b8', fontWeight: 600, fontSize: '0.8rem' }}>#{ex.orderIndex ?? 0}</td>
                        <td>
                          <span className="fw-semibold" style={{ color: '#1e293b' }}>{ex.title}</span>
                        </td>
                        <td><TypeBadge type={ex.type} /></td>
                        <td style={{ color: '#475569' }}>{ex.points ?? 10}</td>
                        <td style={{ color: '#475569' }}>
                          {ex.timeLimitSeconds ? `${ex.timeLimitSeconds}s` : '—'}
                        </td>
                        {canManage && (
                          <td className="text-center">
                            <button className="ex-btn-action me-1" onClick={() => openEdit(ex)}><FiEdit2 size={14} /></button>
                            <button className="ex-btn-action" onClick={() => handleDelete(ex.id)} disabled={deletingId === ex.id}><FiTrash2 size={14} /></button>
                          </td>
                        )}
                      </tr>
                    ))}
                    {exercises.length === 0 && (
                      <tr>
                        <td colSpan={canManage ? 6 : 5} className="text-center text-muted py-4">
                          Chưa có bài tập nào.
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>
            </div>
          )
        )}
      </div>

      {showModal && (
        <div className="modal-backdrop fade show d-flex align-items-center justify-content-center" style={{ background: 'rgba(0,0,0,0.5)', zIndex: 1050 }}>
          <div className="modal show d-block" tabIndex="-1">
            <div className="modal-dialog modal-lg">
              <div className="modal-content">
                <div className="modal-header">
                  <h5 className="modal-title">{editId ? 'Edit Exercise' : 'New Exercise'}</h5>
                  <button type="button" className="btn-close" aria-label="Đóng" onClick={() => setShowModal(false)} />
                </div>
                <form onSubmit={handleSubmit}>
                  <div className="modal-body">
                    <div className="row">
                      <div className="col-md-8 mb-2">
                        <label className="form-label small fw-semibold">Title *</label>
                        <input type="text" className="form-control" value={form.title}
                          onChange={(e) => setForm({ ...form, title: e.target.value })} maxLength={200} required />
                      </div>
                      <div className="col-md-4 mb-2">
                        <label className="form-label small fw-semibold">Type</label>
                        <select className="form-select" value={form.type}
                          onChange={(e) => setForm({ ...form, type: e.target.value })}>
                          {EXERCISE_TYPES.map((t) => <option key={t} value={t}>{typeLabel(t)}</option>)}
                        </select>
                      </div>
                    </div>
                    <div className="mb-2">
                      <label className="form-label small fw-semibold">Question Data (JSON)</label>
                      <textarea className="form-control font-monospace" rows={6}
                        value={form.questionData}
                        onChange={(e) => setForm({ ...form, questionData: e.target.value })}
                        placeholder={'{\n  "question": "...",\n  "options": ["A", "B", "C", "D"],\n  "correctAnswer": 0\n}'}
                        style={{ fontSize: '0.8rem' }}
                      />
                      <div className="form-text small">Nhập JSON hợp lệ cho nội dung câu hỏi.</div>
                    </div>
                    <div className="row">
                      <div className="col-md-4 mb-2">
                        <label className="form-label small fw-semibold">Order Index</label>
                        <input type="number" className="form-control" value={form.orderIndex}
                          onChange={(e) => setForm({ ...form, orderIndex: parseInt(e.target.value) || 0 })} min={0} />
                      </div>
                      <div className="col-md-4 mb-2">
                        <label className="form-label small fw-semibold">Points</label>
                        <input type="number" className="form-control" value={form.points}
                          onChange={(e) => setForm({ ...form, points: parseInt(e.target.value) || 0 })} min={0} />
                      </div>
                      <div className="col-md-4 mb-2">
                        <label className="form-label small fw-semibold">Time Limit (seconds)</label>
                        <input type="number" className="form-control" value={form.timeLimitSeconds}
                          onChange={(e) => setForm({ ...form, timeLimitSeconds: parseInt(e.target.value) || 0 })} min={0}
                          placeholder="0 = no limit" />
                      </div>
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

export default ExerciseList;
