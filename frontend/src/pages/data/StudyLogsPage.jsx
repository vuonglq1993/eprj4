import React, { useEffect, useState } from 'react';
import '../../styles/dataTablesPages.css';
import { getStudyStreak } from '../../services/learningDataService';
import {
  MdLocalFireDepartment,
  MdEmojiEvents,
  MdEventAvailable,
  MdToday,
  MdCalendarMonth,
} from 'react-icons/md';

export default function StudyLogsPage() {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    let cancelled = false;
    (async () => {
      setLoading(true);
      setError('');
      try {
        const res = await getStudyStreak();
        if (!cancelled) setData(res.data || null);
      } catch (err) {
        const d = err.response?.data;
        const msg =
          (typeof d === 'string' && d) ||
          d?.message ||
          d?.code ||
          'Không tải được dữ liệu (API /study-logs/streak).';
        if (!cancelled) setError(msg);
      } finally {
        if (!cancelled) setLoading(false);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, []);

  const fmt = (v) => (v == null || v === '' ? '—' : String(v));

  return (
    <div className="db-page py-4 px-3">
      <div className="db-inner mx-auto">
        <h2 className="fw-bold mb-4" style={{ fontSize: '1.5rem', color: '#1e293b' }}>study_logs</h2>

        {error && <div className="alert alert-danger py-2">{error}</div>}
        {loading ? (
          <div className="text-center py-5 text-muted">Đang tải…</div>
        ) : data && (
          <div className="db-card shadow-sm p-3 p-md-4">
            <nav className="sub-menu" aria-label="Study streak">
              <div className="sub-menu__grid">
                <div className="sub-menu__item sub-menu__item--study">
                  <div className="sub-menu__item-head">
                    <MdLocalFireDepartment size={18} aria-hidden />
                    Chuỗi ngày hiện tại
                  </div>
                  <div className="sub-menu__item-value">{data.currentStreak ?? 0} ngày</div>
                </div>

                <div className="sub-menu__item sub-menu__item--study">
                  <div className="sub-menu__item-head">
                    <MdEmojiEvents size={18} aria-hidden />
                    Kỷ lục streak
                  </div>
                  <div className="sub-menu__item-value">{data.longestStreak ?? 0} ngày</div>
                </div>

                <div className="sub-menu__item sub-menu__item--study">
                  <div className="sub-menu__item-head">
                    <MdEventAvailable size={18} aria-hidden />
                    Lần học gần nhất
                  </div>
                  <div className="sub-menu__item-value">{fmt(data.lastStudyDate)}</div>
                </div>

                <div className="sub-menu__item sub-menu__item--study">
                  <div className="sub-menu__item-head">
                    <MdToday size={18} aria-hidden />
                    Hôm nay đã học
                  </div>
                  <span className={data.studiedToday ? 'sub-menu__badge sub-menu__badge--status-active' : 'sub-menu__badge sub-menu__badge--status-muted'}>
                    {data.studiedToday ? 'Có' : 'Chưa'}
                  </span>
                </div>
              </div>

              <div className="sub-menu__item sub-menu__item--wide sub-menu__item--study">
                <div className="sub-menu__item-head">
                  <MdCalendarMonth size={18} aria-hidden />
                  Các ngày có hoạt động (30 ngày gần nhất)
                </div>
                {(data.studyDates || []).length > 0 ? (
                  <div className="sub-menu__chips">
                    {(data.studyDates || []).map((d) => (
                      <span key={d} className="sub-menu__chip">{fmt(d)}</span>
                    ))}
                  </div>
                ) : (
                  <p className="sub-menu__chip-empty mb-0">Chưa có ngày nào trong 30 ngày gần đây.</p>
                )}
              </div>
            </nav>
          </div>
        )}
      </div>
    </div>
  );
}
