function SalesSection({ data } = {}) {
  const salesData = data?.salesByAge ?? [
    { range: '18-24', filled: 40, empty: 60 },
    { range: '25-34', filled: 70, empty: 30 },
    { range: '35-44', filled: 55, empty: 45 },
    { range: '45-54', filled: 85, empty: 15 },
    { range: '55-64', filled: 35, empty: 65 },
    { range: '65+', filled: 20, empty: 80 },
  ]

  return (
    <section className="dashboard-section dashboard-section--bottom">
      <article className="dashboard-card dashboard-card--wide">
        <header className="dashboard-card__header dashboard-card__header--plain">
          <div>
            <h5 className="dashboard-card__title">Sales by Age</h5>
            <p className="dashboard-card__subtitle">Sales</p>
          </div>
          <select className="dashboard-card__select">
            <option>18-24</option>
            <option>25-34</option>
            <option>35-44</option>
          </select>
        </header>

        <div className="sales-chart">
          <div className="sales-chart__bars">
            {salesData.map((item) => (
              <div key={item.range} className="sales-chart__bar-group">
                <div className="sales-chart__bar sales-chart__bar--filled" style={{ height: `${item.filled}%` }} />
                <div className="sales-chart__bar sales-chart__bar--empty" style={{ height: `${item.empty}%` }} />
                <span className="sales-chart__label">{item.range}</span>
              </div>
            ))}
          </div>
        </div>
      </article>

      <article className="dashboard-card dashboard-card--small">
        <h5 className="dashboard-card__title">Impression</h5>

        <div className="impression-chart">
          <div className="impression-chart__bar-group">
            <div className="impression-chart__bar impression-chart__bar--soft" />
            <div className="impression-chart__bar impression-chart__bar--solid" />
          </div>
          <div className="impression-chart__bar-group">
            <div className="impression-chart__bar impression-chart__bar--soft impression-chart__bar--tall" />
            <div className="impression-chart__bar impression-chart__bar--solid impression-chart__bar--short" />
          </div>
          <div className="impression-chart__bar-group">
            <div className="impression-chart__bar impression-chart__bar--soft impression-chart__bar--short" />
            <div className="impression-chart__bar impression-chart__bar--solid impression-chart__bar--tall" />
          </div>
          <div className="impression-chart__bar-group">
            <div className="impression-chart__bar impression-chart__bar--soft impression-chart__bar--xs" />
            <div className="impression-chart__bar impression-chart__bar--solid impression-chart__bar--md" />
          </div>
        </div>

        <div className="impression-chart__labels">
          <span>Mon</span>
          <span>Tue</span>
          <span>Wed</span>
          <span>Thu</span>
        </div>
      </article>
    </section>
  )
}

export default SalesSection
