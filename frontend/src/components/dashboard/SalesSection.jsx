function SalesSection() {
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
            <div className="sales-chart__bar-group">
              <div className="sales-chart__bar sales-chart__bar--filled" style={{ height: '40%' }} />
              <div className="sales-chart__bar sales-chart__bar--empty" style={{ height: '60%' }} />
              <span className="sales-chart__label">18-24</span>
            </div>
            <div className="sales-chart__bar-group">
              <div className="sales-chart__bar sales-chart__bar--filled" style={{ height: '70%' }} />
              <div className="sales-chart__bar sales-chart__bar--empty" style={{ height: '30%' }} />
              <span className="sales-chart__label">25-34</span>
            </div>
            <div className="sales-chart__bar-group">
              <div className="sales-chart__bar sales-chart__bar--filled" style={{ height: '55%' }} />
              <div className="sales-chart__bar sales-chart__bar--empty" style={{ height: '45%' }} />
              <span className="sales-chart__label">35-44</span>
            </div>
            <div className="sales-chart__bar-group">
              <div className="sales-chart__bar sales-chart__bar--filled" style={{ height: '85%' }} />
              <div className="sales-chart__bar sales-chart__bar--empty" style={{ height: '15%' }} />
              <span className="sales-chart__label">45-54</span>
            </div>
            <div className="sales-chart__bar-group">
              <div className="sales-chart__bar sales-chart__bar--filled" style={{ height: '35%' }} />
              <div className="sales-chart__bar sales-chart__bar--empty" style={{ height: '65%' }} />
              <span className="sales-chart__label">55-64</span>
            </div>
            <div className="sales-chart__bar-group">
              <div className="sales-chart__bar sales-chart__bar--filled" style={{ height: '20%' }} />
              <div className="sales-chart__bar sales-chart__bar--empty" style={{ height: '80%' }} />
              <span className="sales-chart__label">65+</span>
            </div>
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

