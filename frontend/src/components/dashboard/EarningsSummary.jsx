function EarningsSummary() {
  return (
    <aside className="dashboard-card dashboard-card--side">
      <h6 className="dashboard-card__eyebrow">Your earning this month</h6>
      <p className="dashboard-card__side-value">
        735.2<span className="dashboard-card__currency">$</span>
      </p>

      <button type="button" className="dashboard-card__primary-action">
        Withdraw All Earnings
      </button>

      <div className="dashboard-card__side-footer">
        <h6 className="dashboard-card__footer-title">Earnings by item</h6>
        <ul className="dashboard-card__items">
          <li className="dashboard-card__item">
            <div className="dashboard-card__item-icon">
              <span className="dashboard-card__item-dot dashboard-card__item-dot--purple" />
            </div>
            <div className="dashboard-card__item-text">
              <p className="dashboard-card__item-title">Bento 3D Kit</p>
              <p className="dashboard-card__item-subtitle">Illustration</p>
            </div>
            <span className="dashboard-card__item-value">$432</span>
          </li>
          <li className="dashboard-card__item">
            <div className="dashboard-card__item-icon">
              <span className="dashboard-card__item-dot dashboard-card__item-dot--green" />
            </div>
            <div className="dashboard-card__item-text">
              <p className="dashboard-card__item-title">Bento 3D Kit</p>
              <p className="dashboard-card__item-subtitle">Coded Template</p>
            </div>
            <span className="dashboard-card__item-value">$303</span>
          </li>
        </ul>
      </div>
    </aside>
  )
}

export default EarningsSummary

