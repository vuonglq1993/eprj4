const stats = [
  { label: 'Users', value: '35k', subtitle: 'Page views per minute' },
  { label: 'Clicks', value: '1m', subtitle: 'Page views per minute' },
  { label: 'Sales', value: '$345', subtitle: 'Page views per minute' },
  { label: 'Items', value: '68', subtitle: 'Page views per minute' },
]

function StatsSummary() {
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

