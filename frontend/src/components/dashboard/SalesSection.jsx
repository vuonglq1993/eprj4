const RANK_COLORS = ['#f59e0b', '#94a3b8', '#b45309', '#6366f1', '#6366f1']

function SalesSection({ dailyActive, leaderboard } = {}) {
  const labels = dailyActive?.labels ?? []
  const counts = dailyActive?.counts ?? []
  const maxCount = Math.max(...counts, 1)
  const top = leaderboard ?? []

  const shortDate = (iso) => {
    if (!iso) return ''
    const d = new Date(iso)
    return d.toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit' })
  }

  const fmtXp = (xp) => {
    if (xp == null) return '—'
    if (xp >= 1000) return (xp / 1000).toFixed(1) + 'K'
    return String(xp)
  }

  const initials = (user) => {
    const name = user?.displayName ?? user?.fullName ?? user?.firstName ?? '?'
    return name.charAt(0).toUpperCase()
  }

  return (
    <section className="dashboard-section dashboard-section--bottom">
      <article className="dashboard-card dashboard-card--wide">
        <header className="dashboard-card__header dashboard-card__header--plain">
          <div>
            <h5 className="dashboard-card__title">Hoạt động học tập 7 ngày</h5>
            <p className="dashboard-card__subtitle">Học viên có phiên học mỗi ngày</p>
          </div>
        </header>

        <div className="sales-chart">
          <div className="sales-chart__bars">
            {counts.length > 0 ? counts.map((c, i) => {
              const pct = Math.round((c / maxCount) * 100)
              return (
                <div key={labels[i] ?? i} className="sales-chart__bar-group">
                  <div
                    className="sales-chart__bar sales-chart__bar--filled"
                    style={{ height: `${Math.max(pct, 4)}%` }}
                    title={`${c} học viên`}
                  />
                  <div className="sales-chart__bar sales-chart__bar--empty" style={{ height: `${Math.max(100 - pct, 0)}%` }} />
                  <span className="sales-chart__label">{shortDate(labels[i])}</span>
                </div>
              )
            }) : (
              <div style={{ color: '#94a3b8', fontSize: 13, padding: '20px 0' }}>Chưa có dữ liệu</div>
            )}
          </div>
        </div>
      </article>

      <article className="dashboard-card dashboard-card--small">
        <h5 className="dashboard-card__title">Top học viên tuần này</h5>

        <div style={{ marginTop: 12, display: 'flex', flexDirection: 'column', gap: 10 }}>
          {top.length === 0 && (
            <p style={{ fontSize: 13, color: '#94a3b8' }}>Chưa có dữ liệu</p>
          )}
          {top.map((u, i) => (
            <div key={u.userId ?? u.id ?? i} style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
              <span style={{ width: 18, fontSize: 12, fontWeight: 700, color: RANK_COLORS[i] ?? '#6366f1', textAlign: 'right' }}>
                {i + 1}
              </span>
              {u.avatarUrl ? (
                <img src={u.avatarUrl} alt="" style={{ width: 28, height: 28, borderRadius: '50%', objectFit: 'cover' }} />
              ) : (
                <div style={{ width: 28, height: 28, borderRadius: '50%', background: '#334155', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 12, fontWeight: 700, color: '#e2e8f0' }}>
                  {initials(u)}
                </div>
              )}
              <div style={{ flex: 1, minWidth: 0 }}>
                <p style={{ margin: 0, fontSize: 13, fontWeight: 600, color: '#e2e8f0', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                  {u.displayName ?? u.fullName ?? u.firstName ?? 'Học viên'}
                </p>
              </div>
              <span style={{ fontSize: 12, color: '#a78bfa', fontWeight: 600 }}>{fmtXp(u.totalXp ?? u.xp)} XP</span>
            </div>
          ))}
        </div>
      </article>
    </section>
  )
}

export default SalesSection
