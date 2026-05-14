function ActiveUsersCard({ dailyActive } = {}) {
  const labels = dailyActive?.labels ?? []
  const counts = dailyActive?.counts ?? []
  const todayCount = counts.length > 0 ? counts[counts.length - 1] : 0
  const maxCount = Math.max(...counts, 1)

  const shortLabel = (iso) => {
    if (!iso) return ''
    const d = new Date(iso)
    return d.toLocaleDateString('vi-VN', { weekday: 'short' })
  }

  return (
    <article className="dashboard-card dashboard-card--primary">
      <div className="dashboard-card__header">
        <div>
          <h5 className="dashboard-card__title">Học viên hoạt động hôm nay</h5>
          <p className="dashboard-card__subtitle">Số học viên có phiên học trong 7 ngày gần nhất</p>
        </div>
        <span className="dashboard-card__badge">{todayCount > 0 ? todayCount : '0'}</span>
      </div>

      <div className="active-users-chart">
        <div className="active-users-chart__bars">
          {counts.length > 0 ? counts.map((c, i) => {
            const pct = Math.round((c / maxCount) * 100)
            const isToday = i === counts.length - 1
            const heightPx = Math.max(Math.round((c / maxCount) * 112), 11)
            return (
              <div key={labels[i] ?? i} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4 }}>
                <span
                  className="active-users-chart__bar"
                  style={{ height: `${heightPx}px`, opacity: isToday ? 1 : 0.6 }}
                  title={`${labels[i]}: ${c} học viên`}
                />
                <span style={{ fontSize: 9, color: '#94a3b8' }}>{shortLabel(labels[i])}</span>
              </div>
            )
          }) : (
            <>
              <span className="active-users-chart__bar active-users-chart__bar--sm" />
              <span className="active-users-chart__bar active-users-chart__bar--lg" />
              <span className="active-users-chart__bar active-users-chart__bar--md" />
              <span className="active-users-chart__bar active-users-chart__bar--xl" />
              <span className="active-users-chart__bar active-users-chart__bar--md" />
            </>
          )}
        </div>
      </div>
    </article>
  )
}

export default ActiveUsersCard
