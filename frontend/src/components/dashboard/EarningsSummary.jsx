function EarningsSummary({ data } = {}) {
  const earnings = data?.monthlyEarnings ?? 0
  const items = data?.earningsByItem ?? [
    { title: 'Bento 3D Kit', subtitle: 'Illustration', value: 432 },
    { title: 'Bento 3D Kit', subtitle: 'Coded Template', value: 303 },
  ]

  return (
    <aside className="dashboard-card dashboard-card--side">
      <h6 className="dashboard-card__eyebrow">Your earning this month</h6>
      <p className="dashboard-card__side-value">
        {earnings.toFixed(1)}<span className="dashboard-card__currency">$</span>
      </p>

      <button type="button" className="dashboard-card__primary-action">
        Withdraw All Earnings
      </button>

      <div className="dashboard-card__side-footer">
        <h6 className="dashboard-card__footer-title">Earnings by item</h6>
        <ul className="dashboard-card__items">
          {items.map((item, i) => (
            <li key={i} className="dashboard-card__item">
              <div className="dashboard-card__item-icon">
                <span className={`dashboard-card__item-dot ${i === 0 ? 'dashboard-card__item-dot--purple' : 'dashboard-card__item-dot--green'}`} />
              </div>
              <div className="dashboard-card__item-text">
                <p className="dashboard-card__item-title">{item.title}</p>
                <p className="dashboard-card__item-subtitle">{item.subtitle}</p>
              </div>
              <span className="dashboard-card__item-value">${item.value}</span>
            </li>
          ))}
        </ul>
      </div>
    </aside>
  )
}

export default EarningsSummary
