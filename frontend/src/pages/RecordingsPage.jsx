import React, { useEffect, useState, useRef } from 'react';
import { FiMic, FiUpload, FiPlay, FiPause, FiTrash2, FiX, FiChevronDown, FiChevronUp, FiSearch, FiVolume2 } from 'react-icons/fi';
import { uploadRecord, getRecordsByExercise } from '../services/recordService';
import { getCourses } from '../services/courseService';
import { getLessons } from '../services/lessonService';
import { getExercises } from '../services/exerciseService';
import CourseCombobox from '../components/common/CourseCombobox';
import '../styles/recordings.css';

const EMPTY_UPLOAD = { title: '', exerciseId: '' };

function LessonCombobox({ courseId, value, onChange, disabled }) {
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState('');
  const [options, setOptions] = useState([]);
  const [loading, setLoading] = useState(false);
  const [selectedLabel, setSelectedLabel] = useState('');
  const wrapperRef = useRef(null);

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
            {open ? <FiChevronUp size={16} /> : <FiChevronDown size={16} />}
          </span>
        </div>
      </div>
      {open && (
        <div className="course-combobox__dropdown" role="listbox">
          <div className="course-combobox__search-wrapper">
            <FiSearch size={15} className="course-combobox__search-icon" />
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
                </div>
              ))
            )}
          </div>
        </div>
      )}
    </div>
  );
}

function ExerciseCombobox({ courseId, lessonId, value, onChange, disabled }) {
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState('');
  const [options, setOptions] = useState([]);
  const [loading, setLoading] = useState(false);
  const [selectedLabel, setSelectedLabel] = useState('');
  const wrapperRef = useRef(null);

  useEffect(() => {
    if (!lessonId) { setOptions([]); setSelectedLabel(''); return; }
    if (!value) { setSelectedLabel(''); return; }
    const match = options.find((o) => o.id === value);
    if (match) { setSelectedLabel(match.title || match.question?.substring(0, 40) || value); return; }
    (async () => {
      try {
        const res = await getExercises(courseId, lessonId);
        const list = res.data?.content ?? res.data ?? [];
        const found = list.find((e) => e.id === value);
        if (found) setSelectedLabel(found.title || found.question?.substring(0, 40) || value);
      } catch {}
    })();
  }, [value, lessonId]);

  useEffect(() => {
    if (!open || !lessonId) return;
    let cancelled = false;
    (async () => {
      setLoading(true);
      try {
        const res = await getExercises(courseId, lessonId);
        if (!cancelled) setOptions(res.data?.content ?? res.data ?? []);
      } catch {
        if (!cancelled) setOptions([]);
      } finally {
        if (!cancelled) setLoading(false);
      }
    })();
    return () => { cancelled = true; };
  }, [query, open, lessonId]);

  useEffect(() => {
    function handler(e) {
      if (wrapperRef.current && !wrapperRef.current.contains(e.target)) setOpen(false);
    }
    if (open) document.addEventListener('mousedown', handler);
    return () => document.removeEventListener('mousedown', handler);
  }, [open]);

  const handleSelect = (ex) => {
    onChange(ex.id);
    setQuery('');
    setOpen(false);
  };

  const displayed = options.filter((o) =>
    (o.title || o.question || '')?.toLowerCase().includes(query.toLowerCase())
  );

  return (
    <div className="course-combobox" ref={wrapperRef}>
      <div
        className={`course-combobox__control ${disabled ? 'disabled' : ''}`}
        onClick={() => !disabled && lessonId && setOpen((v) => !v)}
        role="combobox"
        aria-expanded={open}
        aria-haspopup="listbox"
        aria-disabled={disabled}
      >
        <span className={`course-combobox__selected-text ${!selectedLabel ? 'placeholder' : ''}`}>
          {selectedLabel || (lessonId ? 'Select exercise…' : 'Select lesson first')}
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
            {open ? <FiChevronUp size={16} /> : <FiChevronDown size={16} />}
          </span>
        </div>
      </div>
      {open && (
        <div className="course-combobox__dropdown" role="listbox">
          <div className="course-combobox__search-wrapper">
            <FiSearch size={15} className="course-combobox__search-icon" />
            <input
              className="course-combobox__search"
              type="text"
              placeholder="Search exercises…"
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
              <div className="course-combobox__message">Không tìm thấy bài tập.</div>
            ) : (
              displayed.map((ex) => (
                <div
                  key={ex.id}
                  className={`course-combobox__option ${ex.id === value ? 'selected' : ''}`}
                  role="option"
                  aria-selected={ex.id === value}
                  onClick={() => handleSelect(ex)}
                >
                  <span className="course-combobox__option-title">
                    {ex.title || ex.question?.substring(0, 40) || ex.id}
                  </span>
                  <span className="course-combobox__option-meta">{ex.type}</span>
                </div>
              ))
            )}
          </div>
        </div>
      )}
    </div>
  );
}

function AudioRecorder({ onRecorded }) {
  const mediaRecorderRef = useRef(null);
  const chunksRef = useRef([]);
  const [status, setStatus] = useState('idle');
  const [duration, setDuration] = useState(0);
  const [audioUrl, setAudioUrl] = useState(null);
  const [blob, setBlob] = useState(null);
  const timerRef = useRef(null);

  const startRecording = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      const mediaRecorder = new MediaRecorder(stream);
      chunksRef.current = [];
      mediaRecorderRef.current = mediaRecorder;

      mediaRecorder.ondataavailable = (e) => {
        if (e.data.size > 0) chunksRef.current.push(e.data);
      };

      mediaRecorder.onstop = () => {
        const b = new Blob(chunksRef.current, { type: 'audio/webm' });
        const url = URL.createObjectURL(b);
        setBlob(b);
        setAudioUrl(url);
        stream.getTracks().forEach((t) => t.stop());
      };

      mediaRecorder.start();
      setStatus('recording');
      setDuration(0);
      timerRef.current = setInterval(() => setDuration((d) => d + 1), 1000);
    } catch {
      alert('Không thể truy cập microphone. Vui lòng cấp quyền.');
    }
  };

  const stopRecording = () => {
    if (mediaRecorderRef.current && mediaRecorderRef.current.state === 'recording') {
      mediaRecorderRef.current.stop();
      clearInterval(timerRef.current);
      setStatus('stopped');
    }
  };

  const discard = () => {
    setAudioUrl(null);
    setBlob(null);
    setStatus('idle');
    setDuration(0);
  };

  useEffect(() => {
    return () => {
      clearInterval(timerRef.current);
      if (audioUrl) URL.revokeObjectURL(audioUrl);
    };
  }, []);

  const formatTime = (s) => {
    const m = Math.floor(s / 60).toString().padStart(2, '0');
    const sec = (s % 60).toString().padStart(2, '0');
    return `${m}:${sec}`;
  };

  return (
    <div className="recorder">
      <div className="recorder__waveform">
        {status === 'recording' && (
          <div className="recorder__bars">
            {[...Array(12)].map((_, i) => (
              <div
                key={i}
                className="recorder__bar"
                style={{ animationDelay: `${(i * 0.08).toFixed(2)}s` }}
              />
            ))}
          </div>
        )}
        {status === 'stopped' && audioUrl && (
          <div className="recorder__preview">
            <FiVolume2 size={18} style={{ color: '#8b5cf6' }} />
            <span className="recorder__preview-text">Preview ready</span>
            <audio src={audioUrl} controls style={{ height: '36px' }} />
          </div>
        )}
        {status === 'idle' && (
          <div className="recorder__idle-text">
            <FiMic size={20} style={{ color: '#94a3b8', marginRight: '6px' }} />
            Click Record to start recording
          </div>
        )}
      </div>

      <div className="recorder__controls">
        {status === 'idle' && (
          <button type="button" className="recorder__btn recorder__btn--record" onClick={startRecording}>
            <FiMic size={18} />
            <span>Record</span>
          </button>
        )}

        {status === 'recording' && (
          <button type="button" className="recorder__btn recorder__btn--stop" onClick={stopRecording}>
            <FiPause size={18} />
            <span>Stop</span>
          </button>
        )}

        {status === 'recording' && (
          <span className="recorder__timer recorder__timer--active">{formatTime(duration)}</span>
        )}

        {status === 'stopped' && (
          <button type="button" className="recorder__btn recorder__btn--discard" onClick={discard}>
            <FiTrash2 size={16} />
            <span>Discard</span>
          </button>
        )}

        {status === 'stopped' && blob && (
          <button
            type="button"
            className="recorder__btn recorder__btn--use"
            onClick={() => onRecorded(blob, audioUrl)}
          >
            Use Recording
          </button>
        )}
      </div>
    </div>
  );
}

const RecordingsPage = () => {
  const [selectedCourse, setSelectedCourse] = useState('');
  const [selectedLesson, setSelectedLesson] = useState('');
  const [selectedExercise, setSelectedExercise] = useState('');

  const [records, setRecords] = useState([]);
  const [recordsLoading, setRecordsLoading] = useState(false);
  const [recordsError, setRecordsError] = useState('');

  const [showUpload, setShowUpload] = useState(false);
  const [uploadForm, setUploadForm] = useState(EMPTY_UPLOAD);
  const [recordedBlob, setRecordedBlob] = useState(null);
  const [recordedAudioUrl, setRecordedAudioUrl] = useState(null);
  const fileInputRef = useRef(null);
  const [uploading, setUploading] = useState(false);
  const [uploadError, setUploadError] = useState('');

  const [playingId, setPlayingId] = useState(null);
  const playingRef = useRef(null);

  useEffect(() => {
    return () => {
      if (playingRef.current) {
        playingRef.current.pause();
        playingRef.current = null;
      }
    };
  }, []);

  const loadRecords = async (exerciseId) => {
    if (!exerciseId) { setRecords([]); return; }
    let cancelled = false;
    setRecordsLoading(true);
    setRecordsError('');
    try {
      const res = await getRecordsByExercise(exerciseId);
      if (!cancelled) setRecords(res.data || []);
    } catch {
      if (!cancelled) setRecordsError('Không tải được danh sách bản ghi.');
    } finally {
      if (!cancelled) setRecordsLoading(false);
    }
  };

  useEffect(() => {
    if (!selectedExercise) { setRecords([]); return; }
    loadRecords(selectedExercise);
  }, [selectedExercise]);

  const handleRecorded = (blob, audioUrl) => {
    setRecordedBlob(blob);
    setRecordedAudioUrl(audioUrl);
    setUploadForm((f) => ({ ...f, title: `Recording ${new Date().toLocaleString()}` }));
  };

  const handleFileChange = (e) => {
    const file = e.target.files?.[0];
    if (!file) return;
    const url = URL.createObjectURL(file);
    setRecordedBlob(file);
    setRecordedAudioUrl(url);
    setUploadForm((f) => ({ ...f, title: file.name.replace(/\.[^.]+$/, '') }));
  };

  const handleUpload = async (e) => {
    e.preventDefault();
    if (!recordedBlob) { setUploadError('Vui lòng ghi âm hoặc chọn file trước.'); return; }
    if (!uploadForm.title.trim()) { setUploadError('Vui lòng nhập tiêu đề.'); return; }
    if (!selectedExercise) { setUploadError('Vui lòng chọn bài tập.'); return; }

    setUploading(true);
    setUploadError('');
    try {
      const ext = recordedBlob.type === 'audio/webm' ? 'webm' : recordedBlob.name?.split('.').pop() || 'mp3';
      const fileName = `recording_${Date.now()}.${ext}`;
      const file = new File([recordedBlob], fileName, { type: recordedBlob.type || 'audio/mp3' });

      const result = await uploadRecord(file, uploadForm.title.trim(), selectedExercise);

      const newRecord = { audioUrl: result.audioUrl, title: result.title };
      setRecords((prev) => [...prev, newRecord]);

      setShowUpload(false);
      setUploadForm(EMPTY_UPLOAD);
      setRecordedBlob(null);
      setRecordedAudioUrl(null);
    } catch (err) {
      setUploadError(err.response?.data?.message || err.message || 'Upload thất bại.');
    } finally {
      setUploading(false);
    }
  };

  const cancelUpload = () => {
    setShowUpload(false);
    setUploadForm(EMPTY_UPLOAD);
    setRecordedBlob(null);
    setRecordedAudioUrl(null);
    setUploadError('');
  };

  const playAudio = (record) => {
    if (playingRef.current) {
      playingRef.current.pause();
      playingRef.current = null;
      if (playingId === record.audioUrl) { setPlayingId(null); return; }
    }
    const audio = new Audio(record.audioUrl);
    playingRef.current = audio;
    setPlayingId(record.audioUrl);
    audio.onended = () => setPlayingId(null);
    audio.play().catch(() => setPlayingId(null));
  };

  return (
    <div className="rec-page py-4 px-3">
      <div className="rec-inner mx-auto">
        <div className="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
          <div>
            <h2 className="fw-bold mb-1" style={{ fontSize: '1.5rem', color: '#1e293b' }}>Recordings</h2>
            <p className="text-muted small mb-0">Ghi âm &amp; quản lý bản ghi audio cho bài tập</p>
          </div>
          <button
            type="button"
            className="btn btn-primary-purple px-4 d-flex align-items-center gap-2"
            onClick={() => setShowUpload(true)}
            disabled={!selectedExercise}
          >
            <FiMic size={16} />
            <span>New Recording</span>
          </button>
        </div>

        <div className="rec-filters mb-3">
          <div className="rec-filter-group">
            <label className="form-label small fw-semibold">Course</label>
            <CourseCombobox value={selectedCourse} onChange={(id) => { setSelectedCourse(id); setSelectedLesson(''); setSelectedExercise(''); setRecords([]); }} />
          </div>
          <div className="rec-filter-group">
            <label className="form-label small fw-semibold">Lesson</label>
            <LessonCombobox courseId={selectedCourse} value={selectedLesson} onChange={(id) => { setSelectedLesson(id); setSelectedExercise(''); setRecords([]); }} />
          </div>
          <div className="rec-filter-group">
            <label className="form-label small fw-semibold">Exercise</label>
            <ExerciseCombobox courseId={selectedCourse} lessonId={selectedLesson} value={selectedExercise} onChange={setSelectedExercise} />
          </div>
        </div>

        {recordsError && <div className="alert alert-danger py-2">{recordsError}</div>}

        {!selectedExercise && (
          <div className="rec-empty-state">
            <FiMic size={40} style={{ color: '#cbd5e1' }} />
            <p>Select a course, lesson, and exercise above to view recordings.</p>
          </div>
        )}

        {recordsLoading ? (
          <div className="text-center py-5 text-muted">Đang tải bản ghi…</div>
        ) : (
          selectedExercise && (
            <div className="rec-card shadow-sm">
              <div className="table-responsive">
                <table className="table rec-table mb-0">
                  <thead>
                    <tr>
                      <th scope="col">#</th>
                      <th scope="col">Title</th>
                      <th scope="col">Audio</th>
                      <th scope="col">Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    {records.map((rec, idx) => (
                      <tr key={rec.audioUrl || idx}>
                        <td style={{ color: '#94a3b8', fontWeight: 600, fontSize: '0.8rem' }}>#{idx + 1}</td>
                        <td>
                          <span className="fw-semibold" style={{ color: '#1e293b' }}>{rec.title}</span>
                        </td>
                        <td>
                          <button
                            type="button"
                            className={`rec-play-btn ${playingId === rec.audioUrl ? 'playing' : ''}`}
                            onClick={() => playAudio(rec)}
                            title={playingId === rec.audioUrl ? 'Stop' : 'Play'}
                          >
                            {playingId === rec.audioUrl
                              ? <FiPause size={14} />
                              : <FiPlay size={14} />
                            }
                          </button>
                        </td>
                        <td className="text-center">
                          <button
                            type="button"
                            className="rec-btn-action"
                            title="Delete"
                            onClick={() => {
                              if (window.confirm('Xóa bản ghi này?')) {
                                setRecords((prev) => prev.filter((r) => r !== rec));
                              }
                            }}
                          >
                            <FiTrash2 size={14} />
                          </button>
                        </td>
                      </tr>
                    ))}
                    {records.length === 0 && (
                      <tr>
                        <td colSpan={4} className="text-center text-muted py-4">
                          Chưa có bản ghi nào cho bài tập này.
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

      {showUpload && (
        <div className="modal-backdrop fade show d-flex align-items-center justify-content-center" style={{ background: 'rgba(0,0,0,0.5)', zIndex: 1050 }}>
          <div className="modal show d-block" tabIndex="-1">
            <div className="modal-dialog modal-lg">
              <div className="modal-content">
                <div className="modal-header">
                  <h5 className="modal-title">New Recording</h5>
                  <button type="button" className="btn-close" aria-label="Close" onClick={cancelUpload} />
                </div>
                <form onSubmit={handleUpload}>
                  <div className="modal-body">
                    <div className="mb-3">
                      <label className="form-label small fw-semibold">Title *</label>
                      <input
                        type="text"
                        className="form-control"
                        value={uploadForm.title}
                        onChange={(e) => setUploadForm((f) => ({ ...f, title: e.target.value }))}
                        placeholder="e.g. Speaking Practice - Unit 1"
                        maxLength={150}
                        required
                      />
                    </div>

                    <div className="mb-3">
                      <label className="form-label small fw-semibold">Audio Source</label>
                      <div className="upload-source-tabs">
                        <span className="upload-source-tab active">🎙️ Microphone</span>
                        <span className="upload-source-hint">Chọn microphone để ghi âm trực tiếp</span>
                      </div>
                    </div>

                    <AudioRecorder onRecorded={handleRecorded} />

                    <div className="upload-divider">
                      <span>or upload file</span>
                    </div>

                    <div className="mb-3">
                      <label className="form-label small fw-semibold">Audio File</label>
                      <div className="upload-file-zone">
                        <input
                          ref={fileInputRef}
                          type="file"
                          accept="audio/*"
                          style={{ display: 'none' }}
                          onChange={handleFileChange}
                        />
                        <button
                          type="button"
                          className="btn btn-outline-secondary d-flex align-items-center gap-2"
                          onClick={() => fileInputRef.current?.click()}
                        >
                          <FiUpload size={16} />
                          <span>Choose File</span>
                        </button>
                        {recordedBlob && (
                          <span className="upload-file-name">
                            {recordedBlob.name || 'Audio ready'}
                          </span>
                        )}
                      </div>
                    </div>

                    {uploadError && (
                      <div className="alert alert-danger py-2 mb-0">{uploadError}</div>
                    )}
                  </div>
                  <div className="modal-footer">
                    <button type="button" className="btn btn-secondary" onClick={cancelUpload}>
                      Cancel
                    </button>
                    <button
                      type="submit"
                      className="btn btn-primary-purple"
                      disabled={uploading || !recordedBlob}
                    >
                      {uploading ? 'Đang upload…' : 'Upload'}
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

export default RecordingsPage;
