import React, { useEffect, useState } from 'react';
import '../styles/gamereview.css';
import { getWeeklyReport } from '../services/gamificationService';
import { getApiErrorMessage } from '../utils/apiError';

const DAY_LABELS = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

function deltaLabel(delta, suffix = '') {
  if (delta == null || delta === 0) return null;
  const sign = delta > 0 ? '+' : '';
  return `${sign}${delta}${suffix}`;
}

function typeBadgeClass(type) {
  return `gm-type-badge gm-type-badge--${type || 'VOCABULARY'}`;
}

export default function WeeklyReportPage() {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    getWeeklyReport()
      .then((res) => setData(res.data))
      .catch((err) => setError(getApiErrorMessage(err) || 'Không tải được báo cáo tuần.'))
      .finally(() => setLoading(false));
  }, []);

  if (loading) {
    return (
      <div className="gm-page py-4 px-3">
        <div className="gm-inner">
          <div style={{ textAlign: 'center', padding: '60px', color: '#94a3b8' }}>Đang tải…</div>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="gm-page py-4 px-3">
        <div className="gm-inner">
          <div className="gm-card">
            <div className="alert alert-danger py-2">{error}</div>
          </div>
        </div>
      </div>
    );
  }

  const report = data || {};
  const weekLabel = report.weekStart && report.weekEnd
    ? `${report.weekStart} → ${report.weekEnd}`
    : 'Báo cáo tuần này';

  // Build 7-day grid from daily array
  const dailyMap = {};
  (report.daily || []).forEach((d) => {
    dailyMap[d.dayLabel || d.date] = d;
  });
  const maxMin = Math.max(...Object.values(dailyMap).map((d) => d?.studyMinutes || 0), 1);

  const statCards = [
    {
      label: 'Tổng thời gian',
      value: `${report.totalStudyMinutes ?? 0} phút`,
      delta: deltaLabel(report.minutesVsLastWeek, ' phút'),
      cls: '',
    },
    {
      label: 'Bài học hoàn thành',
      value: report.totalLessonsCompleted ?? 0,
      delta: deltaLabel(report.lessonsVsLastWeek),
      cls: '',
    },
    {
      label: 'Bài tập đã làm',
      value: report.totalExercisesDone ?? 0,
      delta: null,
      cls: '',
    },
    {
      label: 'Điểm trung bình',
      value: report.averageScore != null ? `${report.averageScore}%` : '—',
      delta: deltaLabel(report.scoreVsLastWeek, '%'),
      cls: '',
    },
    {
      label: 'Chuỗi streak',
      value: `${report.currentStreak ?? 0} ngày 🔥`,
      delta: null,
      cls: 'gm-report-stat--streak',
    },
    {
      label: 'XP tuần này',
      value: `+${report.xpEarnedThisWeek ?? 0} XP`,
      delta: null,
      cls: 'gm-report-stat--xp',
    },
  ];

  return (
    <div className="gm-page py-4 px-3">
      <div className="gm-inner">

        <div className="mb-4">
          <h2 style={{ fontSize: '1.5rem', fontWeight: 800, color: '#1e293b', margin: 0 }}>Báo cáo tuần</h2>
          <p style={{ color: '#64748b', fontSize: '0.85rem', margin: '4px 0 0' }}>{weekLabel}</p>
        </div>

        {/* Overview stats */}
        <div className="gm-report-grid">
          {statCards.map((s) => (
            <div key={s.label} className={`gm-report-stat ${s.cls}`}>
              <div className="gm-report-stat__label">{s.label}</div>
              <div className="gm-report-stat__value">{s.value}</div>
              {s.delta && (
                <div className={`gm-report-stat__delta ${s.delta.startsWith('+') ? 'gm-report-stat__delta--up' : 'gm-report-stat__delta--down'}`}>
                  {s.delta} so tuần trước
                </div>
              )}
            </div>
          ))}
        </div>

        {/* Daily chart */}
        <div className="gm-section" style={{ marginBottom: 20 }}>
          <h3 className="gm-section__title">Hoạt động hàng ngày</h3>
          <div className="gm-report-daily">
            {DAY_LABELS.map((day) => {
              const d = dailyMap[day] || {};
              const minutes = d.studyMinutes || 0;
              const pct = minutes / maxMin;
              return (
                <div key={day} className="gm-report-day">
                  <div className="gm-report-day__label">{day}</div>
                  <div className="gm-report-day__bar">
                    <div
                      className="gm-report-day__fill"
                      style={{ height: `${Math.max(pct * 100, 2)}%` }}
                    />
                  </div>
                  <div className={`gm-report-day__min ${d.studiedToday ? 'gm-report-day__min--active' : ''}`}>
                    {minutes > 0 ? `${minutes}m` : '—'}
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 20, marginBottom: 20 }}>
          {/* Skills */}
          <div className="gm-section">
            <h3 className="gm-section__title">Kỹ năng</h3>
            {report.strongestSkill && (
              <div className="gm-report-skill" style={{ marginBottom: 10 }}>
                <div className="gm-report-skill__label">Kỹ năng mạnh nhất</div>
                <div className="gm-report-skill__name gm-report-skill__name--strong">
                  {report.strongestSkill} 💪
                </div>
              </div>
            )}
            {report.weakestSkill && (
              <div className="gm-report-skill">
                <div className="gm-report-skill__label">Kỹ năng cần cải thiện</div>
                <div className="gm-report-skill__name gm-report-skill__name--weak">
                  {report.weakestSkill} 📚
                </div>
              </div>
            )}
            {!report.strongestSkill && !report.weakestSkill && (
              <p style={{ color: '#94a3b8', fontSize: '0.85rem', margin: 0 }}>Chưa có dữ liệu kỹ năng.</p>
            )}
          </div>

          {/* New badges */}
          <div className="gm-section">
            <h3 className="gm-section__title">Huy hiệu mới</h3>
            {report.newBadges && report.newBadges.length > 0 ? (
              <div className="gm-report-badges">
                {report.newBadges.map((badge, i) => (
                  <span key={i} className="gm-report-badge">{badge}</span>
                ))}
              </div>
            ) : (
              <p style={{ color: '#94a3b8', fontSize: '0.85rem', margin: 0 }}>Tuần này chưa nhận huy hiệu mới.</p>
            )}
          </div>
        </div>

        {/* Course progress */}
        {report.courses && report.courses.length > 0 && (
          <div className="gm-section" style={{ marginBottom: 20 }}>
            <h3 className="gm-section__title">Tiến độ khóa học</h3>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
              {report.courses.map((course, i) => (
                <div key={i}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 4 }}>
                    <span style={{ fontSize: '0.85rem', fontWeight: 600, color: '#334155' }}>{course.courseTitle}</span>
                    <span style={{ fontSize: '0.85rem', fontWeight: 700, color: '#6366f1' }}>{course.progressPercent ?? 0}%</span>
                  </div>
                  <div style={{ height: 6, background: '#f1f5f9', borderRadius: 4, overflow: 'hidden' }}>
                    <div style={{ width: `${course.progressPercent ?? 0}%`, height: '100%', background: '#6366f1', borderRadius: 4, transition: 'width 0.4s' }} />
                  </div>
                  <div style={{ fontSize: '0.75rem', color: '#94a3b8', marginTop: 2 }}>
                    {course.lessonsThisWeek ?? 0} bài học tuần này
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Motivation */}
        {report.motivationMessage && (
          <div className="gm-motivation">
            {report.motivationMessage}
          </div>
        )}

      </div>
    </div>
  );
}
