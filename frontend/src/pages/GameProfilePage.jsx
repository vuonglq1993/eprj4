import React, { useEffect, useState } from 'react';
import '../styles/gamereview.css';
import { getGameProfile } from '../services/gamificationService';
import { getApiErrorMessage } from '../utils/apiError';

function initials(name) {
  if (!name) return '?';
  return name.split(' ').map((p) => p[0]).join('').slice(0, 2).toUpperCase();
}

function levelColor(level) {
  if (level >= 8) return '#7c3aed';
  if (level >= 5) return '#d97706';
  if (level >= 3) return '#0369a1';
  return '#475569';
}

export default function GameProfilePage() {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    getGameProfile()
      .then((res) => setData(res.data))
      .catch((err) => setError(getApiErrorMessage(err) || 'Không tải được Game Profile.'))
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

  const profile = data || {};
  const xpToNext = profile.xpToNextLevel ?? 0;
  const xpCurrent = profile.xpCurrentLevel ?? 0;
  const xpTotal = xpToNext + xpCurrent;
  const xpPct = xpTotal > 0 ? Math.round((xpCurrent / xpTotal) * 100) : 0;
  const lvlColor = levelColor(profile.level ?? 1);

  return (
    <div className="gm-page py-4 px-3">
      <div className="gm-inner">

        {/* Profile header */}
        <div className="gm-card" style={{ marginBottom: 20 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 20, flexWrap: 'wrap' }}>
            {/* Avatar */}
            <div style={{
              width: 80, height: 80, borderRadius: '50%',
              background: '#6366f1', overflow: 'hidden', flexShrink: 0,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              fontSize: 28, fontWeight: 700, color: '#fff',
            }}>
              {profile.avatarUrl ? (
                <img src={profile.avatarUrl} alt={profile.userName} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
              ) : (
                initials(profile.userName)
              )}
            </div>

            {/* Info */}
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: '1.4rem', fontWeight: 800, color: '#1e293b', marginBottom: 4 }}>
                {profile.userName || '—'}
              </div>
              <div style={{ display: 'flex', alignItems: 'center', gap: 8, flexWrap: 'wrap' }}>
                <span className="gm-level-badge" style={{ background: lvlColor }}>
                  {profile.levelTitle || `Level ${profile.level ?? 1}`}
                </span>
                <span style={{ fontSize: '0.85rem', color: '#64748b' }}>
                  Level {profile.level ?? 1}
                </span>
              </div>
            </div>

            {/* Stats */}
            <div style={{ display: 'flex', gap: 24, flexWrap: 'wrap' }}>
              <div style={{ textAlign: 'center' }}>
                <div style={{ fontSize: '1.5rem', fontWeight: 800, color: '#6366f1' }}>{profile.totalXp ?? 0}</div>
                <div style={{ fontSize: '0.75rem', color: '#64748b', fontWeight: 600, textTransform: 'uppercase' }}>Total XP</div>
              </div>
              <div style={{ textAlign: 'center' }}>
                <div style={{ fontSize: '1.5rem', fontWeight: 800, color: '#f59e0b' }}>{profile.weeklyXp ?? 0}</div>
                <div style={{ fontSize: '0.75rem', color: '#64748b', fontWeight: 600, textTransform: 'uppercase' }}>XP tuần này</div>
              </div>
              <div style={{ textAlign: 'center' }}>
                <div style={{ fontSize: '1.5rem', fontWeight: 800, color: '#10b981' }}>{profile.badges?.length ?? 0}</div>
                <div style={{ fontSize: '0.75rem', color: '#64748b', fontWeight: 600, textTransform: 'uppercase' }}>Badges</div>
              </div>
            </div>
          </div>

          {/* XP progress bar */}
          <div style={{ marginTop: 20 }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 6 }}>
              <span style={{ fontSize: '0.78rem', fontWeight: 600, color: '#64748b' }}>
                {xpCurrent} / {xpTotal} XP — Level {profile.level ?? 1}
              </span>
              <span style={{ fontSize: '0.78rem', fontWeight: 700, color: '#6366f1' }}>{xpPct}%</span>
            </div>
            <div className="gm-xp-track">
              <div className="gm-xp-fill" style={{ width: `${xpPct}%` }} />
            </div>
          </div>
        </div>

        {/* Badges */}
        <div className="gm-section">
          <h3 className="gm-section__title">
            Huy hiệu đã đạt được
            <span style={{ marginLeft: 8, fontSize: '0.85rem', color: '#64748b', fontWeight: 500 }}>
              ({profile.badges?.length ?? 0})
            </span>
          </h3>
          {profile.badges && profile.badges.length > 0 ? (
            <div className="gm-badges">
              {profile.badges.map((badge, i) => (
                <div key={i} className={`gm-badge-card${i === 0 ? ' gm-badge-card--new' : ''}`}>
                  <div className="gm-badge-icon">{badge.iconUrl || '🏆'}</div>
                  <div className="gm-badge-name">{badge.name}</div>
                  <div className="gm-badge-desc">{badge.description}</div>
                  {badge.earnedAt && (
                    <div className="gm-badge-date">
                      {new Date(badge.earnedAt).toLocaleDateString('vi-VN')}
                    </div>
                  )}
                </div>
              ))}
            </div>
          ) : (
            <p style={{ color: '#94a3b8', fontSize: '0.9rem', margin: 0 }}>
              Chưa có huy hiệu nào. Hãy học tập để nhận huy hiệu đầu tiên!
            </p>
          )}
        </div>

      </div>
    </div>
  );
}
