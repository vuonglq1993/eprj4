function StatsSummary({ data } = {}) {
  const fmtNum = (n) => {
    if (n == null) return '—';
    if (n >= 1000) return (n / 1000).toFixed(1) + 'k';
    return String(n);
  };

  const stats = [
    {
      label: 'Học viên',
      value: fmtNum(data?.totalUsers),
      subtitle: 'Tổng số tài khoản',
    },
    {
      label: 'Khoá học',
      value: data?.totalCourses ?? '—',
      subtitle: 'Khoá học hiện có',
    },
    {
      label: 'Gói Premium',
      value: data?.premiumUsers != null ? fmtNum(data.premiumUsers) : '—',
      subtitle: 'Đang dùng gói trả phí',
    },
    {
      label: 'Doanh thu',
      value: data?.totalRevenue != null ? `${(data.totalRevenue / 1000).toFixed(0)}K₫` : '—',
      subtitle: 'Tổng doanh thu',
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
