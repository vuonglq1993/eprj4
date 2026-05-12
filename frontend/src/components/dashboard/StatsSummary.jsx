function StatsSummary({ data } = {}) {
  const fmtNum = (n) => {
    if (n == null) return '—';
    if (n >= 1000) return (n / 1000).toFixed(1) + 'k';
    return String(n);
  };

  const stats = [
    {
      label: 'Users',
      value: fmtNum(data?.totalUsers),
      subtitle: 'Total registered users',
    },
    {
      label: 'Courses',
      value: data?.totalCourses ?? '—',
      subtitle: 'Available courses',
    },
    {
      label: 'Active Sessions',
      value: data?.activeSessions ?? '—',
      subtitle: 'Currently online',
    },
    {
      label: 'Revenue',
      value: data?.totalRevenue != null ? `$${data.totalRevenue.toFixed(1)}` : '—',
      subtitle: 'Total earnings',
    },
  ]

  return (
    <section className="dashboard-section">
      <div className="dashboard-grid dashboard-grid--stats">
        {stats.map((item) => (
          <article key={item.label} className="dashboard-card dashboard-card--stat">
            <div className="dashboard-card__stat-header">
              <h6 className="dashboard-card__label">{item.label}</h6>
            </div>
            <p className="dashboard-card__value">{item.value}</p>
            <p className="dashboard-card__stat-subtitle">{item.subtitle}</p>
          </article>
        ))}
      </div>
    </section>
  )
}

export default StatsSummary
