import KpiCard from '../components/analytics/KpiCard'
import SalesFunnelChart from '../components/analytics/SalesFunnelChart'
import DeviceCategory from '../components/analytics/DeviceCategory'
import WatchlistsChart from '../components/analytics/WatchlistsChart'
import TopCountries from '../components/analytics/TopCountries'

function Analytics() {
  return (
    <div className="analytics-page">
      <section className="analytics-kpis">
        <KpiCard
          title="Available to withdraw"
          value="$1,567.99"
          detail="Wed, Jul 20"
          trend="10.0%"
          trendUp
        />
        <KpiCard
          title="Today Revenue"
          value="$2,868.99"
          detail="143 Orders"
          trend="3.0%"
          trendUp={false}
        />
        <KpiCard
          title="Today Sessions"
          value="156k"
          detail="32k Visitors"
          trend="3.2%"
          trendUp
        />
        <KpiCard
          title="Subscribers"
          value="3,422"
          detail="$32.48 Average Order"
          trend="8.3%"
          trendUp
        />
      </section>

      <section className="analytics-charts-row">
        <SalesFunnelChart />
        <DeviceCategory />
      </section>

      <section className="analytics-charts-row">
        <WatchlistsChart />
        <TopCountries />
      </section>
    </div>
  )
}

export default Analytics
