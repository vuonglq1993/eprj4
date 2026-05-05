import React, { useEffect, useState } from 'react';
import '../styles/exerciselist.css';
import { FiEdit2, FiTrash2, FiPlus, FiCheckCircle, FiZap } from 'react-icons/fi';
import { getExercises, createExercise, updateExercise, deleteExercise } from '../services/exerciseService';
import { getCourses } from '../services/courseService';
import { getLessons } from '../services/lessonService';
import { isAdmin, hasRole } from '../utils/roleUtils';

// Backend ExerciseType enum: MULTIPLE_CHOICE | FILL_IN_BLANK | LISTENING_CHOICE | SPEAKING | TRANSLATION | MATCHING | DRAG_DROP
const EXERCISE_TYPES = [
  { value: 'MULTIPLE_CHOICE',  label: 'Multiple Choice' },
  { value: 'FILL_IN_BLANK',     label: 'Fill in Blank' },
  { value: 'LISTENING_CHOICE',  label: 'Listening Choice' },
  { value: 'SPEAKING',          label: 'Speaking' },
  { value: 'TRANSLATION',       label: 'Translation' },
  { value: 'MATCHING',           label: 'Matching' },
  { value: 'DRAG_DROP',          label: 'Drag & Drop' },
];
const EMPTY_FORM = { title: '', type: 'MULTIPLE_CHOICE', questionData: '{}', orderIndex: 0, points: 10, timeLimitSeconds: 0 };

const QUESTION_DATA_TEMPLATES = {
  MULTIPLE_CHOICE: '{\n  "question": "Which greeting is correct at 3 PM?",\n  "options": ["Good morning", "Good afternoon", "Good night", "See you"],\n  "correctIndex": 1,\n  "explanation": "3 PM is afternoon, so use Good afternoon."\n}',
  FILL_IN_BLANK: '{\n  "question": "My name _____ John. Nice to meet you.",\n  "answer": "is",\n  "hints": ["verb to be"],\n  "explanation": "Use is with singular name in present simple."\n}',
  LISTENING_CHOICE: '{\n  "question": "Listen and choose the correct answer.",\n  "audioUrl": "https://example.com/audio.mp3",\n  "options": ["Option A", "Option B", "Option C", "Option D"],\n  "correctIndex": 0,\n  "explanation": "Listen carefully to the audio."\n}',
  SPEAKING: '{\n  "question": "Introduce yourself in 5 sentences.",\n  "targetText": "My name is ... I am ... years old.",\n  "expected_keywords": ["name", "years old", "from", "hobby"],\n  "sample_answer": "My name is John. I am 25 years old. I am from New York. My hobby is reading.",\n  "hint": "Include your name, age, and where you are from."\n}',
  TRANSLATION: '{\n  "question": "Translate to English: Xin chào, tôi tên là John.",\n  "answer": "Hello, my name is John.",\n  "hints": ["greeting phrase"],\n  "explanation": "Use the appropriate greeting and introduce yourself."\n}',
  MATCHING: '{\n  "pairs": [\n    { "left": "Good morning", "right": "Before noon" },\n    { "left": "Good afternoon", "right": "Noon to 6 PM" },\n    { "left": "Good evening", "right": "6 PM" },\n    { "left": "Good night", "right": "Before sleep" }\n  ]\n}',
  DRAG_DROP: '{\n  "pairs": [\n    { "left": "Subject", "right": "The cat" },\n    { "left": "Verb", "right": "jumped" },\n    { "left": "Object", "right": "the fence" }\n  ]\n}',
};

function normalizeQuestionDataForForm(raw) {
  if (raw == null || raw === '') return '{}';
  if (typeof raw === 'string') return raw;
  try {
    return JSON.stringify(raw, null, 2);
  } catch {
    return '{}';
  }
}

/** Kiểm tra chuỗi là JSON object hợp lệ (backend lưu dạng string JSON). */
function validateQuestionDataJson(text) {
  const trimmed = (text || '').trim();
  if (!trimmed) {
    return { ok: false, message: 'Ô "Dữ liệu câu hỏi" không được để trống. Dùng ít nhất {} hoặc chọn "Chèn ví dụ".' };
  }
  let parsed;
  try {
    parsed = JSON.parse(trimmed);
  } catch (e) {
    return {
      ok: false,
      message: `Chuỗi không phải JSON hợp lệ (${e.message || 'lỗi cú pháp'}). JSON cần có dấu ngoặc {}, dấu ngoặc kép " cho chữ, và dấu phẩy đúng chỗ.`,
    };
  }
  if (parsed === null || typeof parsed !== 'object' || Array.isArray(parsed)) {
    return { ok: false, message: 'JSON phải là một object dạng { ... }, không phải mảng [] hay số/chuỗi đơn.' };
  }
  return { ok: true, parsed };
}

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
  return map[t] || (t ? t.charAt(0) + t.slice(1).toLowerCase() : '—');
};

function DiffBadge({ diff }) {
  const label = diff || 'Easy';
  return <span className={`ex-badge ex-badge--${label.toLowerCase()}`}>{label}</span>;
}

function TypeTag({ type }) {
  return <span className="ex-type">{typeLabel(type)}</span>;
}

function AutoGradedTag({ auto }) {
  return auto
    ? <span className="ex-graded"><FiCheckCircle size={11} /> Auto</span>
    : <span className="ex-graded ex-graded--manual"><FiZap size={11} /> Manual</span>;
}

const ExerciseList = () => {
  const [exercises, setExercises] = useState([]);
  const [coursesLoading, setCoursesLoading] = useState(true);
  const [lessonsLoading, setLessonsLoading] = useState(false);
  const [exercisesLoading, setExercisesLoading] = useState(false);
  const [error, setError] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [editId, setEditId] = useState(null);
  const [form, setForm] = useState(EMPTY_FORM);
  const [courses, setCourses] = useState([]);
  const [lessons, setLessons] = useState([]);
  const [selectedCourse, setSelectedCourse] = useState('');
  const [selectedLesson, setSelectedLesson] = useState('');
  const [saving, setSaving] = useState(false);
  const [questionJsonError, setQuestionJsonError] = useState('');
  const canManage = isAdmin() || hasRole('TEACHER');
  const loading = coursesLoading || lessonsLoading || exercisesLoading;

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

  const fetchLessons = async (courseId) => {
    if (!courseId) {
      setLessons([]);
      setSelectedLesson('');
      return;
    }
    setLessonsLoading(true);
    try {
      const res = await getLessons(courseId);
      const list = res.data || [];
      setLessons(list);
      setSelectedLesson(list.length > 0 ? list[0].id : '');
    } catch {
      setError('Không tải được danh sách bài học.');
      setLessons([]);
      setSelectedLesson('');
    } finally {
      setLessonsLoading(false);
    }
  };

  const fetchExercises = async () => {
    if (!selectedCourse || !selectedLesson) return;
    setExercisesLoading(true);
    setError('');
    try {
      const res = await getExercises(selectedCourse, selectedLesson);
      setExercises(res.data || []);
    } catch {
      setError('Không tải được danh sách bài tập.');
    } finally {
      setExercisesLoading(false);
    }
  };

  useEffect(() => {
    fetchCourses();
  }, []);

  useEffect(() => {
    if (selectedCourse) fetchLessons(selectedCourse);
    else {
      setLessons([]);
      setSelectedLesson('');
      setExercises([]);
    }
  }, [selectedCourse]);

  useEffect(() => {
    if (selectedCourse && selectedLesson) fetchExercises();
    else setExercises([]);
  }, [selectedCourse, selectedLesson]);

  const openCreate = () => {
    setEditId(null);
    setForm({ ...EMPTY_FORM, type: 'MULTIPLE_CHOICE' });
    setQuestionJsonError('');
    setShowModal(true);
  };

  const openEdit = (ex) => {
    setEditId(ex.id);
    setForm({
      title: ex.title || '',
      type: ex.type || 'MULTIPLE_CHOICE',
      questionData: normalizeQuestionDataForForm(ex.questionData),
      orderIndex: ex.orderIndex ?? 0,
      points: ex.points ?? 10,
      timeLimitSeconds: ex.timeLimitSeconds ?? 0,
    });
    setQuestionJsonError('');
    setShowModal(true);
  };

  const handleDelete = async (exerciseId) => {
    if (!window.confirm('Xóa bài tập này?')) return;
    try {
      await deleteExercise(selectedCourse, selectedLesson, exerciseId);
      setExercises((prev) => prev.filter((e) => e.id !== exerciseId));
    } catch {
      alert('Xóa thất bại.');
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!form.title.trim()) { alert('Vui lòng nhập tiêu đề bài tập.'); return; }
    const jsonCheck = validateQuestionDataJson(form.questionData);
    if (!jsonCheck.ok) {
      setQuestionJsonError(jsonCheck.message);
      return;
    }
    setQuestionJsonError('');
    const payload = {
      ...form,
      questionData: JSON.stringify(jsonCheck.parsed),
    };
    setSaving(true);
    try {
      if (editId) {
        const res = await updateExercise(selectedCourse, selectedLesson, editId, payload);
        setExercises((prev) => prev.map((ex) => ex.id === editId ? res.data : ex));
      } else {
        const res = await createExercise(selectedCourse, selectedLesson, payload);
        setExercises((prev) => [...prev, res.data]);
      }
      setShowModal(false);
    } catch (err) {
      const d = err.response?.data;
      const serverMsg =
        (typeof d === 'string' && d) ||
        d?.message ||
        d?.error ||
        (Array.isArray(d?.errors) && d.errors.map((x) => x?.defaultMessage || x).filter(Boolean).join(' ')) ||
        err.message;
      alert(serverMsg || (err.response?.status === 409 ? 'Đã tồn tại.' : 'Lưu thất bại.'));
    } finally {
      setSaving(false);
    }
  };

  const getDifficulty = (ex) => {
    const p = ex.points ?? 10;
    if (p <= 10) return 'Easy';
    if (p <= 15) return 'Medium';
    return 'Hard';
  };

  const getAutoGraded = (type) =>
    ['MULTIPLE_CHOICE', 'FILL_IN_BLANK', 'LISTENING_CHOICE', 'TRANSLATION', 'MATCHING', 'DRAG_DROP'].includes(type);

  const currentLesson = lessons.find((l) => l.id === selectedLesson);

  return (
    <div className="ex-page py-4 px-3">
      <div className="ex-inner mx-auto">
        <div className="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
          <div>
            <h2 className="fw-bold mb-1" style={{ fontSize: '1.5rem', color: '#1e293b' }}>Exercises</h2>
            <p className="text-muted small mb-0">Manage exercises for each lesson</p>
          </div>
          {canManage && selectedLesson && (
            <button type="button" className="btn btn-primary-purple px-4 d-flex align-items-center gap-2" onClick={openCreate}>
              <FiPlus size={16} /> New Exercise
            </button>
          )}
        </div>

        {canManage && (
          <div className="row mb-3 g-2">
            <div className="col-md-6">
              <label className="form-label small fw-semibold">Course</label>
              <select className="form-select" value={selectedCourse} onChange={(e) => setSelectedCourse(e.target.value)}>
                <option value="">Select course…</option>
                {courses.map((c) => <option key={c.id} value={c.id}>{c.title}</option>)}
              </select>
            </div>
            <div className="col-md-6">
              <label className="form-label small fw-semibold">Lesson</label>
              <select className="form-select" value={selectedLesson} onChange={(e) => setSelectedLesson(e.target.value)} disabled={!selectedCourse}>
                <option value="">Select lesson…</option>
                {lessons.map((l) => <option key={l.id} value={l.id}>{l.title}</option>)}
              </select>
            </div>
          </div>
        )}

        {error && <div className="alert alert-danger py-2">{error}</div>}

        {loading ? (
          <div className="text-center py-5 text-muted">
            {coursesLoading ? 'Đang tải khóa học…' : lessonsLoading ? 'Đang tải bài học…' : 'Đang tải bài tập…'}
          </div>
        ) : (
          <div className="ex-grid">
            {exercises.map((ex) => (
              <div key={ex.id} className="ex-card shadow-sm">
                <div className="ex-card-header">
                  <div className="d-flex align-items-center gap-2 flex-wrap">
                    <TypeTag type={ex.type} />
                    <DiffBadge diff={getDifficulty(ex)} />
                    <AutoGradedTag auto={getAutoGraded(ex.type)} />
                  </div>
                  {canManage && (
                    <div className="ex-card-actions">
                      <button className="ll-btn-action me-1" onClick={() => openEdit(ex)}><FiEdit2 size={13} /></button>
                      <button className="ll-btn-action" onClick={() => handleDelete(ex.id)}><FiTrash2 size={13} /></button>
                    </div>
                  )}
                </div>
                <div className="ex-card-body">
                  <p className="ex-question mb-3">{ex.title}</p>
                </div>
                <div className="ex-card-footer">
                  <span className="ex-lesson">{currentLesson?.title || '—'}</span>
                  <span className="ex-points">{ex.points ?? 10} pts</span>
                </div>
              </div>
            ))}
            {exercises.length === 0 && (
              <div className="text-center text-muted py-5 w-100">Chưa có bài tập nào.</div>
            )}
          </div>
        )}
      </div>

      {showModal && (
        <div className="modal-backdrop fade show d-flex align-items-center justify-content-center" style={{ background: 'rgba(0,0,0,0.5)', zIndex: 1050 }}>
          <div className="modal show d-block" tabIndex="-1">
            <div className="modal-dialog">
              <div className="modal-content">
                <div className="modal-header">
                  <h5 className="modal-title">{editId ? 'Edit Exercise' : 'New Exercise'}</h5>
                  <button type="button" className="btn-close" aria-label="Đóng" onClick={() => setShowModal(false)} />
                </div>
                <form onSubmit={handleSubmit}>
                  <div className="modal-body">
                    <div className="mb-2">
                      <label className="form-label small fw-semibold">Title *</label>
                      <input type="text" className="form-control" value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} maxLength={150} required />
                    </div>
                    <div className="row">
                      <div className="col-md-6 mb-2">
                        <label className="form-label small fw-semibold">Type</label>
                        <select className="form-select" value={form.type} onChange={(e) => setForm({ ...form, type: e.target.value })}>
                          {EXERCISE_TYPES.map((t) => <option key={t.value} value={t.value}>{t.label}</option>)}
                        </select>
                      </div>
                      <div className="col-md-3 mb-2">
                        <label className="form-label small fw-semibold">Points</label>
                        <input type="number" className="form-control" value={form.points} onChange={(e) => setForm({ ...form, points: parseInt(e.target.value) || 0 })} min={1} />
                      </div>
                      <div className="col-md-3 mb-2">
                        <label className="form-label small fw-semibold">Time Limit (s)</label>
                        <input type="number" className="form-control" value={form.timeLimitSeconds} onChange={(e) => setForm({ ...form, timeLimitSeconds: parseInt(e.target.value) || 0 })} min={0} />
                      </div>
                    </div>
                    <div className="mb-2">
                      <div className="d-flex flex-wrap align-items-center justify-content-between gap-2 mb-1">
                        <label className="form-label small fw-semibold mb-0">Dữ liệu câu hỏi (JSON) *</label>
                        <button
                          type="button"
                          className="btn btn-sm btn-outline-secondary"
                          onClick={() => {
                            const tpl = QUESTION_DATA_TEMPLATES[form.type] || QUESTION_DATA_TEMPLATES.MULTIPLE_CHOICE;
                            setForm((f) => ({ ...f, questionData: tpl }));
                            setQuestionJsonError('');
                          }}
                        >
                          Chèn ví dụ theo loại
                        </button>
                      </div>
                      <p className="small text-muted mb-2 mb-md-1" style={{ lineHeight: 1.45 }}>
                        Server lưu nội dung bài tập (câu hỏi, đáp án, v.v.) dưới dạng <strong>một chuỗi JSON</strong>.
                        Nếu sai cú pháp (ví dụ <code>{'ffdfdfds{}'}</code>) thì không parse được — cần đúng định dạng như <code>{'{"question":"..."}'}</code>.
                      </p>
                      <textarea
                        className={`form-control font-monospace small ${questionJsonError ? 'is-invalid' : ''}`}
                        rows={8}
                        spellCheck={false}
                        value={form.questionData}
                        onChange={(e) => {
                          setQuestionJsonError('');
                          setForm({ ...form, questionData: e.target.value });
                        }}
                        placeholder='{"question":"...","options":["A","B","C","D"],"correctIndex":0}'
                      />
                      {questionJsonError ? (
                        <div className="invalid-feedback d-block">{questionJsonError}</div>
                      ) : (
                        <small className="text-muted">Trắc nghiệm thường dùng: <code>question</code>, <code>options</code> (mảng), <code>correctAnswer</code>. Đổi loại bài rồi bấm &quot;Chèn ví dụ&quot; để xem gợi ý.</small>
                      )}
                    </div>
                    <div className="mb-2">
                      <label className="form-label small fw-semibold">Order Index</label>
                      <input type="number" className="form-control" value={form.orderIndex} onChange={(e) => setForm({ ...form, orderIndex: parseInt(e.target.value) || 0 })} min={0} />
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

export default ExerciseList;
