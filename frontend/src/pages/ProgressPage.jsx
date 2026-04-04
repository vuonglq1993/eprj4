import React, { useEffect, useState } from 'react';
import '../styles/progresspage.css';
import { FiAward, FiTarget, FiClock, FiTrendingUp } from 'react-icons/fi';
import { FaFire } from 'react-icons/fa6';
import { getDashboard, getProgressStats } from '../services/progressService';
import { getStreak } from '../services/studyLogService';
import { getApiErrorMessage } from '../utils/apiError';

const PERIOD_OPTIONS = [
  { label: 'This Week', value: 'WEEK' },
  { label: 'This Month', value: 'MONTH' },
  { label: 'This Year', value: 'YEAR' },
];

function StatCard({ label, value, unit, icon: Icon, color, bg }) {
  return (
    <div className="pp-stat-card shadow-sm">
      <div className="d-flex justify-content-between align-items-start mb-3">
        <div className="pp-stat-icon" style={{ backgroundColor: bg }}>
          <Icon size={20} style={{ color }} />
        </div>
        <span className="pp-stat-value fw-bold" style={{ color: '#1e293b' }}>
          {value}<span className="pp-stat-unit"> {unit}</span>
        </span>
      </div>
      <span className="pp-stat-label" style={{ color: '#64748b' }}>{label}</span>
    </div>
  );
}

const ProgressPage = () => {
  const [dash, setDash] = useState(null);
  const [stats, setStats] = useState(null);
  const [streak, setStreak] = useState(null);
  const [period, setPeriod] = useState('WEEK');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  const fetchAll = async () => {
    setLoading(true);
    setError('');
    try {
      const [dashRes, statsRes, streakRes] = await Promise.all([
        getDashboard(),
        getProgressStats(period),
        getStreak(),
      ]);
      setDash(dashRes.data);
      setStats(statsRes.data);
      setStreak(streakRes.data);
    } catch (err) {
      const status = err.response?.status;
      const msg = getApiErrorMessage(err);
      if (status === 401 || status === 403) {
        setError(msg || 'Phiên đăng nhập không hợp lệ hoặc đã hết hạn. Vui lòng đăng nhập lại.');
      } else {
        setError(msg || 'Không tải được dữ liệu tiến độ. Kiểm tra kết nối hoặc thử lại sau.');
      }
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchAll(); }, [period]);

  if (loading) {
    return (
      <div className="pp-page py-4 px-3">
        <div className="pp-inner mx-auto text-center py-5 text-muted">Đang tải…</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="pp-page py-4 px-3">
        <div className="pp-inner mx-auto">
          <div className="alert alert-danger py-2">{error}</div>
        </div>
      </div>
    );
  }

  const streakData = streak || {};
  const dashData = dash || {};
  const statsData = stats || {};
  const thisWeek = dashData.thisWeek || {};
  const activeCourses = dashData.activeCourses || [];
  const skills = dashData.skills || {};
  const daily = thisWeek.daily || [];
  const dailyMap = {};
  if (daily.length > 0) daily.forEach((d) => { dailyMap[d.dayLabel || d.date] = d; });

  const weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const maxMin = Math.max(...weekDays.map((d) => dailyMap[d]?.studyMinutes || 0), 1);

  const statCards = [
    {
      label: 'Current Streak',
      value: streakData.currentStreak ?? dashData.currentStreak ?? 0,
      unit: 'days',
      icon: FaFire,
      color: '#f59e0b',
      bg: '#fef3c7',
    },
    {
      label: 'Total Study Time',
      value: Math.round(((dashData.totalStudyMinutes ?? 0) + (streakData.currentStreak ?? 0) * 30) / 60),
      unit: 'hours',
      icon: FiClock,
      color: '#6366f1',
      bg: '#eef2ff',
    },
    {
      label: 'Courses Enrolled',
      value: dashData.totalCoursesEnrolled ?? 0,
      unit: 'courses',
      icon: FiTrendingUp,
      color: '#10b981',
      bg: '#d1fae5',
    },
    {
      label: 'Exercises Solved',
      value: dashData.totalExercisesDone ?? statsData.totalExercises ?? 0,
      unit: 'solved',
      icon: FiTarget,
      color: '#f43f5e',
      bg: '#ffe4e6',
    },
  ];

  return (
    <div className="pp-page py-4 px-3">
      <div className="pp-inner mx-auto">
        <div className="mb-4">
          <h2 className="fw-bold mb-1" style={{ fontSize: '1.5rem', color: '#1e293b' }}>My Progress</h2>
          <p className="text-muted small mb-0">Track your learning journey and achievements</p>
        </div>

        {/* Stat cards */}
        <div className="pp-stats-grid mb-4">
          {statCards.map((s) => (
            <StatCard key={s.label} {...s} />
          ))}
        </div>

        <div className="row g-4">
          {/* Weekly activity */}
          <div className="col-md-5">
            <div className="pp-card shadow-sm">
              <div className="d-flex justify-content-between align-items-center mb-1">
                <div>
                  <h5 className="fw-bold mb-0" style={{ fontSize: '0.95rem', color: '#1e293b' }}>Weekly Activity</h5>
                  <p className="text-muted small mb-0">Minutes studied per day</p>
                </div>
                <div className="d-flex gap-2 align-items-center">
                  <span className="text-muted small">{streakData.longestStreak ? `Best: ${streakData.longestStreak}d` : ''}</span>
                  {streakData.studiedToday && (
                    <span className="badge bg-success">Today done</span>
                  )}
                </div>
              </div>
              <div className="d-flex align-items-end gap-2 mt-3" style={{ height: 120 }}>
                {weekDays.map((day) => {
                  const dayData = dailyMap[day] || {};
                  const minutes = dayData.studyMinutes || 0;
                  const pct = minutes / maxMin;
                  return (
                    <div key={day} className="pp-bar-col flex-fill d-flex flex-column align-items-center gap-1">
                      <div
                        className="pp-bar"
                        style={{
                          height: `${Math.max(pct * 100, 4)}%`,
                          backgroundColor: minutes > 0 ? '#6366f1' : '#e2e8f0',
                          width: '100%',
                          borderRadius: '6px 6px 0 0',
                          minHeight: 4,
                          transition: 'height 0.3s',
                        }}
                      />
                      <span className="pp-bar-label">{day}</span>
                    </div>
                  );
                })}
              </div>
            </div>
          </div>

          {/* Course progress */}
          <div className="col-md-7">
            <div className="pp-card shadow-sm">
              <div className="d-flex justify-content-between align-items-center mb-1">
                <div>
                  <h5 className="fw-bold mb-0" style={{ fontSize: '0.95rem', color: '#1e293b' }}>Course Progress</h5>
                  <p className="text-muted small mb-0">How far you have come</p>
                </div>
                <select
                  className="form-select form-select-sm"
                  style={{ width: 'auto' }}
                  value={period}
                  onChange={(e) => setPeriod(e.target.value)}
                >
                  {PERIOD_OPTIONS.map((p) => (
                    <option key={p.value} value={p.value}>{p.label}</option>
                  ))}
                </select>
              </div>
              <div className="d-flex flex-column gap-3 mt-3">
                {activeCourses.length > 0 ? activeCourses.map((course) => (
                  <div key={course.courseId}>
                    <div className="d-flex justify-content-between mb-1">
                      <span style={{ fontSize: '0.82rem', color: '#475569', fontWeight: 500 }}>{course.courseTitle}</span>
                      <span style={{ fontSize: '0.82rem', color: '#6366f1', fontWeight: 700 }}>{course.progressPercent ?? 0}%</span>
                    </div>
                    <div className="pp-progress-bar">
                      <div
                        className="pp-progress-fill"
                        style={{ width: `${course.progressPercent ?? 0}%`, backgroundColor: '#6366f1' }}
                      />
                    </div>
                    <div className="d-flex gap-3 mt-1">
                      <span className="text-muted" style={{ fontSize: '0.75rem' }}>{course.completedLessons ?? 0}/{course.totalLessons ?? 0} lessons</span>
                      <span className="text-muted" style={{ fontSize: '0.75rem' }}>Score: {course.averageScore ?? 0}%</span>
                    </div>
                  </div>
                )) : (
                  <p className="text-muted small">Chưa đăng ký khóa học nào.</p>
                )}
              </div>
            </div>

            {/* Skills breakdown */}
            {(skills.listening || skills.speaking || skills.reading || skills.vocabulary) ? (
              <div className="pp-card shadow-sm mt-3">
                <h5 className="fw-bold mb-3" style={{ fontSize: '0.95rem', color: '#1e293b' }}>Skill Breakdown</h5>
                <div className="row g-3">
                  {[
                    { label: 'Listening', data: skills.listening },
                    { label: 'Speaking', data: skills.speaking },
                    { label: 'Reading', data: skills.reading },
                    { label: 'Vocabulary', data: skills.vocabulary },
                    { label: 'Grammar', data: skills.grammar },
                  ].filter((s) => s.data).map((s) => (
                    <div key={s.label} className="col-6">
                      <div className="d-flex justify-content-between mb-1">
                        <span style={{ fontSize: '0.8rem', color: '#475569' }}>{s.label}</span>
                        <span style={{ fontSize: '0.8rem', color: '#6366f1', fontWeight: 600 }}>
                          {s.data?.averageScore ?? 0}%
                        </span>
                      </div>
                      <div className="pp-progress-bar">
                        <div
                          className="pp-progress-fill"
                          style={{ width: `${s.data?.averageScore ?? 0}%`, backgroundColor: '#0ea5e9' }}
                        />
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            ) : null}
          </div>
        </div>
      </div>
    </div>
  );
};

export default ProgressPage;
