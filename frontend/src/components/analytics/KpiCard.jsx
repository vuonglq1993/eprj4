function KpiCard({ title, value, detail, trend, trendUp }) {
  return (
    <article className="analytics-kpi">
      <div className="analytics-kpi__header">
        <span className="analytics-kpi__title">{title}</span>
        {trend != null && (
          <span className={`analytics-kpi__trend analytics-kpi__trend--${trendUp ? 'up' : 'down'}`}>
            {trendUp ? '▲' : '▼'} {trend}
          </span>
        )}
      </div>
      <p className="analytics-kpi__value">{value}</p>
      {detail && <p className="analytics-kpi__detail">{detail}</p>}
    </article>
  )
}

export default KpiCard
