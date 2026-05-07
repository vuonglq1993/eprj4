function ActiveUsersCard({ data } = {}) {
  const activeCount = data?.activeUsers ?? 0
  return (
    <article className="dashboard-card dashboard-card--primary">
      <div className="dashboard-card__header">
        <div>
          <h5 className="dashboard-card__title">Active users right now</h5>
          <p className="dashboard-card__subtitle">Upgrade your payout method in setting</p>
        </div>
        <span className="dashboard-card__badge">{activeCount > 0 ? activeCount : '—'}</span>
      </div>

      <div className="active-users-chart">
        <div className="active-users-chart__bars">
          <span className="active-users-chart__bar active-users-chart__bar--sm" />
          <span className="active-users-chart__bar active-users-chart__bar--lg" />
          <span className="active-users-chart__bar active-users-chart__bar--md" />
          <span className="active-users-chart__bar active-users-chart__bar--xl" />
          <span className="active-users-chart__bar active-users-chart__bar--md" />
        </div>
      </div>
    </article>
  )
}

export default ActiveUsersCard
