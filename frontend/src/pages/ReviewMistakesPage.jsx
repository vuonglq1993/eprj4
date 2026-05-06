import React, { useEffect, useState } from 'react';
import '../styles/gamereview.css';
import { getMistakes } from '../services/gamificationService';
import { getApiErrorMessage } from '../utils/apiError';

function fmtDate(iso) {
  if (!iso) return '—';
  try {
    return new Date(iso).toLocaleDateString('vi-VN', {
      year: 'numeric', month: 'short', day: 'numeric',
    });
  } catch {
    return iso;
  }
}

function typeBadgeClass(type) {
  return `gm-type-badge gm-type-badge--${type || 'VOCABULARY'}`;
}

export default function ReviewMistakesPage() {
  const [mistakes, setMistakes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [page, setPage] = useState(0);
  const [totalPages, setTotalPages] = useState(0);
  const pageSize = 20;

  const fetchMistakes = (p = 0) => {
    setLoading(true);
    setError('');
    getMistakes(p, pageSize)
      .then((res) => {
        const d = res.data;
        setMistakes(Array.isArray(d) ? d : d?.content ?? d?.data ?? []);
        setTotalPages(d?.totalPages ?? 0);
        setPage(p);
      })
      .catch((err) => setError(getApiErrorMessage(err) || 'Không tải được danh sách.'))
      .finally(() => setLoading(false));
  };

  useEffect(() => { fetchMistakes(0); }, []);

  return (
    <div className="gm-page py-4 px-3">
      <div className="gm-inner">

        <div className="mb-4">
          <h2 style={{ fontSize: '1.5rem', fontWeight: 800, color: '#1e293b', margin: 0 }}>Ôn tập lỗi sai</h2>
          <p style={{ color: '#64748b', fontSize: '0.85rem', margin: '4px 0 0' }}>
            Những bài tập bạn đã làm sai — học lại để cải thiện
          </p>
        </div>

        {error && <div className="alert alert-danger py-2 mb-3">{error}</div>}

        {loading ? (
          <div className="text-center py-5 text-muted">Đang tải…</div>
        ) : (
          <>
            <div className="gm-card">
              <table className="gm-mistakes-table">
                <thead>
                  <tr>
                    <th>Bài tập</th>
                    <th>Loại</th>
                    <th>Đáp án</th>
                    <th>Số lần sai</th>
                    <th>Ngày</th>
                  </tr>
                </thead>
                <tbody>
                  {mistakes.map((m) => (
                    <tr key={m.exerciseId || `${m.exerciseId}-${m.attemptedAt}`}>
                      <td>
                        <div className="gm-mistakes-question">{m.exerciseTitle || '—'}</div>
                        <div className="gm-mistakes-meta">
                          {m.lessonTitle && <span>📖 {m.lessonTitle}</span>}
                          {m.courseTitle && <span style={{ marginLeft: 8 }}>📚 {m.courseTitle}</span>}
                        </div>
                        {m.explanation && (
                          <div className="gm-explanation">{m.explanation}</div>
                        )}
                      </td>
                      <td>
                        <span className={typeBadgeClass(m.exerciseType)}>
                          {m.exerciseType?.replace(/_/g, ' ') || '—'}
                        </span>
                      </td>
                      <td>
                        <div className="gm-mistakes-answer">
                          {m.userAnswer && (
                            <span className="gm-answer-wrong">Sai: {m.userAnswer}</span>
                          )}
                          {m.correctAnswer && (
                            <span className="gm-answer-correct">Đúng: {m.correctAnswer}</span>
                          )}
                        </div>
                      </td>
                      <td>
                        <span className="gm-times-wrong">
                          🔁 {m.timesWrong ?? 1} lần
                        </span>
                      </td>
                      <td style={{ fontSize: '0.8rem', color: '#64748b', whiteSpace: 'nowrap' }}>
                        {fmtDate(m.attemptedAt)}
                      </td>
                    </tr>
                  ))}
                  {mistakes.length === 0 && (
                    <tr>
                      <td colSpan={5} className="text-center text-muted py-5">
                        🎉 Chưa có lỗi sai nào. Hãy tiếp tục học!
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>

            {/* Pagination */}
            {totalPages > 1 && (
              <div className="gm-pagination">
                <button onClick={() => fetchMistakes(0)} disabled={page === 0}>« Đầu</button>
                <button onClick={() => fetchMistakes(page - 1)} disabled={page === 0}>‹ Trước</button>
                <span className="gm-pagination__info">Trang {page + 1} / {totalPages}</span>
                <button onClick={() => fetchMistakes(page + 1)} disabled={page >= totalPages - 1}>Sau ›</button>
                <button onClick={() => fetchMistakes(totalPages - 1)} disabled={page >= totalPages - 1}>Cuối »</button>
              </div>
            )}
          </>
        )}

      </div>
    </div>
  );
}
