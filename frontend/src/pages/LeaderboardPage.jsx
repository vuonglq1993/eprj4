import React, { useEffect, useState } from 'react';
import '../styles/gamereview.css';
import { getLeaderboard } from '../services/gamificationService';
import { getApiErrorMessage } from '../utils/apiError';

const TABS = [
  { key: 'weekly', label: 'Bảng xếp hạng tuần' },
  { key: 'allTime', label: 'Tất cả thời gian' },
];

function initials(name) {
  if (!name) return '?';
  return name.split(' ').map((p) => p[0]).join('').slice(0, 2).toUpperCase();
}

function rankClass(rank) {
  if (rank === 1) return 'gm-lb-rank--1';
  if (rank === 2) return 'gm-lb-rank--2';
  if (rank === 3) return 'gm-lb-rank--3';
  return '';
}

export default function LeaderboardPage() {
  const [activeTab, setActiveTab] = useState('weekly');
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    setLoading(true);
    setError('');
    getLeaderboard(activeTab)
      .then((res) => setData(res.data))
      .catch((err) => setError(getApiErrorMessage(err) || 'Không tải được Leaderboard.'))
      .finally(() => setLoading(false));
  }, [activeTab]);

  const lbData = data || {};
  const list = lbData[activeTab] || [];

  return (
    <div className="gm-page py-4 px-3">
      <div className="gm-inner">

        <div className="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
          <div>
            <h2 style={{ fontSize: '1.5rem', fontWeight: 800, color: '#1e293b', margin: 0 }}>Bảng xếp hạng</h2>
            <p style={{ color: '#64748b', fontSize: '0.85rem', margin: '4px 0 0' }}>So sánh thành tích với những người học khác</p>
          </div>
          <div className="gm-tabs">
            {TABS.map((t) => (
              <button
                key={t.key}
                type="button"
                className={`gm-tab ${activeTab === t.key ? 'gm-tab--active' : ''}`}
                onClick={() => setActiveTab(t.key)}
              >
                {t.label}
              </button>
            ))}
          </div>
        </div>

        {error && <div className="alert alert-danger py-2 mb-3">{error}</div>}

        {loading ? (
          <div className="text-center py-5 text-muted">Đang tải…</div>
        ) : (
          <>
            <div className="gm-card">
              <table className="gm-lb-table">
                <thead>
                  <tr>
                    <th style={{ width: 60 }}>#</th>
                    <th>Người dùng</th>
                    <th>Level</th>
                    <th>XP</th>
                  </tr>
                </thead>
                <tbody>
                  {list.map((entry, i) => {
                    const isMe = lbData.myRank && lbData.myRank.userId === entry.userId;
                    const rank = entry.rank ?? i + 1;
                    return (
                      <tr key={entry.userId || i} className={isMe ? 'gm-lb-rank--me' : ''}>
                        <td>
                          <span className={`gm-lb-rank ${rankClass(rank)}`}>
                            {rank === 1 ? '🥇' : rank === 2 ? '🥈' : rank === 3 ? '🥉' : rank}
                          </span>
                        </td>
                        <td>
                          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                            <div className="gm-lb-avatar">
                              {entry.avatarUrl ? (
                                <img src={entry.avatarUrl} alt={entry.userName} />
                              ) : (
                                initials(entry.userName)
                              )}
                            </div>
                            <div>
                              <div style={{ fontWeight: 600, color: '#1e293b', fontSize: '0.9rem' }}>
                                {entry.userName || '—'}
                                {isMe && <span style={{ marginLeft: 6, fontSize: '0.72rem', color: '#6366f1', fontWeight: 700 }}>(Bạn)</span>}
                              </div>
                            </div>
                          </div>
                        </td>
                        <td>
                          <span className="gm-lb-level">
                            {entry.levelTitle || `Lv.${entry.level ?? '?'}`}
                          </span>
                        </td>
                        <td>
                          <span className="gm-lb-xp">{entry.xp?.toLocaleString() ?? 0} XP</span>
                        </td>
                      </tr>
                    );
                  })}
                  {list.length === 0 && (
                    <tr>
                      <td colSpan={4} className="text-center text-muted py-4">
                        Chưa có dữ liệu bảng xếp hạng.
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>

            {/* My rank */}
            {lbData.myRank && (
              <div className="gm-card mt-3" style={{ borderLeft: '4px solid #6366f1' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                  <div>
                    <div style={{ fontSize: '0.72rem', fontWeight: 700, textTransform: 'uppercase', color: '#64748b', marginBottom: 4 }}>
                      Xếp hạng của bạn
                    </div>
                    <div style={{ fontSize: '1.4rem', fontWeight: 800, color: '#6366f1' }}>
                      #{lbData.myRank.rank ?? '?'}
                    </div>
                  </div>
                  <div style={{ flex: 1, paddingLeft: 16, borderLeft: '1px solid #e2e8f0' }}>
                    <div style={{ fontWeight: 600, color: '#1e293b' }}>{lbData.myRank.levelTitle || `Level ${lbData.myRank.level}`}</div>
                    <div style={{ fontSize: '0.82rem', color: '#64748b' }}>{lbData.myRank.xp?.toLocaleString() ?? 0} XP tổng</div>
                  </div>
                </div>
              </div>
            )}
          </>
        )}

      </div>
    </div>
  );
}
