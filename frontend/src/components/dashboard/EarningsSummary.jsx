const PLAN_DOTS = [
  { key: 'free',        label: 'Miễn phí',   cls: 'dashboard-card__item-dot--gray'   },
  { key: 'monthly',     label: 'Tháng',       cls: 'dashboard-card__item-dot--purple' },
  { key: 'threeMonths', label: '3 Tháng',     cls: 'dashboard-card__item-dot--blue'   },
  { key: 'yearly',      label: 'Năm',         cls: 'dashboard-card__item-dot--green'  },
]

function EarningsSummary({ subBreakdown } = {}) {
  const total   = subBreakdown?.total          ?? 0
  const revenue = subBreakdown?.monthlyRevenue ?? 0

  const fmtRevenue = (v) => {
    if (v >= 1_000_000) return (v / 1_000_000).toFixed(1) + 'M'
    if (v >= 1_000)     return (v / 1_000).toFixed(1) + 'K'
    return v.toFixed(0)
  }

  return (
    <aside className="dashboard-card dashboard-card--side">
      <h6 className="dashboard-card__eyebrow">Doanh thu tháng này</h6>
      <p className="dashboard-card__side-value">
        {fmtRevenue(revenue)}<span className="dashboard-card__currency">₫</span>
      </p>

      <div style={{ fontSize: 13, color: '#94a3b8', marginBottom: 12 }}>
        Tổng học viên đang hoạt động: <strong style={{ color: '#e2e8f0' }}>{total}</strong>
      </div>

      <div className="dashboard-card__side-footer">
        <h6 className="dashboard-card__footer-title">Phân loại gói</h6>
        <ul className="dashboard-card__items">
          {PLAN_DOTS.map(({ key, label, cls }) => (
            <li key={key} className="dashboard-card__item">
              <div className="dashboard-card__item-icon">
                <span className={`dashboard-card__item-dot ${cls}`} />
              </div>
              <div className="dashboard-card__item-text">
                <p className="dashboard-card__item-title">{label}</p>
              </div>
              <span className="dashboard-card__item-value">{subBreakdown?.[key] ?? 0}</span>
            </li>
          ))}
        </ul>
      </div>
    </aside>
  )
}

export default EarningsSummary
