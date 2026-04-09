import React, { useEffect, useState } from 'react';
import '../styles/onboarding.css';
import { FiCheckCircle } from 'react-icons/fi';
import { useNavigate } from 'react-router-dom';
import { getOnboardingStatus, submitOnboarding } from '../services/onboardingService';
import { getLanguages } from '../services/languageService';
import { getMyPaths } from '../services/learningPathService';
import { useAuth } from '../contexts/AuthContext';

const QUESTIONS = [
  {
    id: 'nativeLanguage',
    question: 'Ngôn ngữ mẹ đẻ của bạn là gì?',
    type: 'select',
    optionsKey: 'languages',
    placeholder: 'Chọn ngôn ngữ mẹ đẻ…',
  },
  {
    id: 'learningLanguage',
    question: 'Bạn muốn học ngôn ngữ nào?',
    type: 'select',
    optionsKey: 'languages',
    placeholder: 'Chọn ngôn ngữ muốn học…',
  },
  {
    id: 'currentLevel',
    question: 'Trình độ hiện tại của bạn ở ngôn ngữ muốn học?',
    type: 'radio',
    options: [
      { value: 'BEGINNER', label: 'Beginner — Mới bắt đầu' },
      { value: 'INTERMEDIATE', label: 'Intermediate — Trung cấp' },
      { value: 'ADVANCED', label: 'Advanced — Nâng cao' },
    ],
  },
  {
    id: 'goal',
    question: 'Mục tiêu học tập của bạn là gì?',
    type: 'radio',
    options: [
      { value: 'CONVERSATION', label: 'Giao tiếp thông thường' },
      { value: 'WORK', label: 'Công việc / Nghề nghiệp' },
      { value: 'TRAVEL', label: 'Du lịch / Định cư' },
      { value: 'ACADEMIC', label: 'Học thuật / Thi chứng chỉ' },
    ],
  },
  {
    id: 'dailyMinutes',
    question: 'Bạn có thể dành bao nhiêu phút mỗi ngày để học?',
    type: 'radio',
    options: [
      { value: '15', label: '15 phút — Tôi bận' },
      { value: '30', label: '30 phút — Khá ổn định' },
      { value: '60', label: '1 giờ — Tôi nghiêm túc' },
      { value: '120', label: '2+ giờ — Tôi cực kỳ nghiêm túc' },
    ],
  },
];

function OnboardingPage() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [step, setStep] = useState(0);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [completed, setCompleted] = useState(false);
  const [error, setError] = useState('');
  const [languages, setLanguages] = useState([]);
  const [suggestedPath, setSuggestedPath] = useState(null);
  const [answers, setAnswers] = useState({
    nativeLanguage: '',
    learningLanguage: '',
    currentLevel: '',
    goal: '',
    dailyMinutes: '',
  });

  useEffect(() => {
    const init = async () => {
      try {
        const [statusRes, langRes, pathsRes] = await Promise.all([
          getOnboardingStatus(),
          getLanguages(),
          getMyPaths(),
        ]);
        const statusData = statusRes.data || {};
        if (statusData.onboardingCompleted) {
          setCompleted(true);
          setAnswers(statusData.answers || {});
        }
        setLanguages(langRes.data || []);
        if (pathsRes.data?.length > 0) {
          setSuggestedPath(pathsRes.data[0]);
        }
      } catch {
        setError('Không tải được dữ liệu onboarding.');
      } finally {
        setLoading(false);
      }
    };
    init();
  }, []);

  const currentQ = QUESTIONS[step];
  const progress = ((step + 1) / QUESTIONS.length) * 100;

  const handleAnswer = (id, value) => {
    setAnswers((prev) => ({ ...prev, [id]: value }));
  };

  const handleNext = () => {
    if (step < QUESTIONS.length - 1) {
      setStep(step + 1);
    }
  };

  const handlePrev = () => {
    if (step > 0) setStep(step - 1);
  };

  const handleSubmit = async () => {
    if (!answers.nativeLanguage || !answers.learningLanguage || !answers.currentLevel || !answers.goal || !answers.dailyMinutes) {
      alert('Vui lòng trả lời tất cả câu hỏi.');
      return;
    }
    setSubmitting(true);
    try {
      const res = await submitOnboarding({
        nativeLanguage: answers.nativeLanguage,
        learningLanguage: answers.learningLanguage,
        currentLevel: answers.currentLevel,
        goal: answers.goal,
        dailyMinutes: Number(answers.dailyMinutes),
      });
      const data = res.data || {};
      setSuggestedPath(data.suggestedPath || null);
      setCompleted(true);
    } catch (err) {
      alert(err.response?.data?.message || 'Lưu onboarding thất bại.');
    } finally {
      setSubmitting(false);
    }
  };

  const handleGoToDashboard = () => {
    navigate('/');
  };

  if (loading) {
    return (
      <div className="ob-page">
        <div className="ob-card">
          <div className="text-center py-5 text-muted">Đang tải…</div>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="ob-page">
        <div className="ob-card">
          <div className="alert alert-danger py-2">{error}</div>
        </div>
      </div>
    );
  }

  if (completed) {
    return (
      <div className="ob-page">
        <div className="ob-card ob-card--complete">
          <div className="ob-complete-icon">
            <FiCheckCircle size={64} style={{ color: '#10b981' }} />
          </div>
          <h2 className="fw-bold mb-2" style={{ color: '#1e293b' }}>Onboarding Complete!</h2>
          <p className="text-muted mb-4">
            Chào {user?.name || user?.email || 'bạn'}! Bạn đã hoàn thành setup.
            {suggestedPath && (
              <> Hãy bắt đầu với lộ trình <strong>{suggestedPath.title}</strong> nhé.</>
            )}
          </p>
          <button type="button" className="btn btn-primary-purple px-5 py-2" onClick={handleGoToDashboard}>
            Đi đến Dashboard
          </button>
        </div>
      </div>
    );
  }

  const q = currentQ;
  const options = q.optionsKey === 'languages' ? languages : (q.options || []);
  const currentAnswer = answers[q.id];

  return (
    <div className="ob-page">
      <div className="ob-card">
        <div className="ob-progress-bar-wrap">
          <div className="ob-progress-bar-fill" style={{ width: `${progress}%` }} />
        </div>
        <div className="ob-step-label">
          Step {step + 1} / {QUESTIONS.length}
        </div>

        <h2 className="ob-question">{q.question}</h2>

        {q.type === 'select' && (
          <select
            className="form-select ob-select"
            value={currentAnswer}
            onChange={(e) => handleAnswer(q.id, e.target.value)}
          >
            <option value="">{q.placeholder}</option>
            {options.map((o) => (
              <option key={o.id || o.value} value={o.id || o.code || o.value}>
                {o.name || o.label || o.nativeName || o}
              </option>
            ))}
          </select>
        )}

        {q.type === 'radio' && (
          <div className="ob-options">
            {q.options.map((opt) => (
              <label key={opt.value} className={`ob-option ${currentAnswer === opt.value ? 'ob-option--selected' : ''}`}>
                <input
                  type="radio"
                  name={q.id}
                  value={opt.value}
                  checked={currentAnswer === opt.value}
                  onChange={() => handleAnswer(q.id, opt.value)}
                />
                <span>{opt.label}</span>
              </label>
            ))}
          </div>
        )}

        <div className="ob-nav">
          {step > 0 && (
            <button type="button" className="btn btn-secondary" onClick={handlePrev}>
              Back
            </button>
          )}
          {step < QUESTIONS.length - 1 ? (
            <button
              type="button"
              className="btn btn-primary-purple"
              onClick={handleNext}
              disabled={!currentAnswer}
            >
              Next
            </button>
          ) : (
            <button
              type="button"
              className="btn btn-primary-purple"
              onClick={handleSubmit}
              disabled={submitting || !currentAnswer}
            >
              {submitting ? 'Đang lưu…' : 'Hoàn thành'}
            </button>
          )}
        </div>
      </div>
    </div>
  );
}

export default OnboardingPage;
