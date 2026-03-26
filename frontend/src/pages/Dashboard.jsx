import ActiveUsersCard from '../components/dashboard/ActiveUsersCard.jsx'
import StatsSummary from '../components/dashboard/StatsSummary.jsx'
import EarningsSummary from '../components/dashboard/EarningsSummary.jsx'
import SalesSection from '../components/dashboard/SalesSection.jsx'

function Dashboard() {
  return (
    <div className="dashboard">
      <section className="dashboard-section dashboard-section--top">
        <div className="dashboard-grid dashboard-grid--top">
          <ActiveUsersCard />
          <EarningsSummary />
        </div>
      </section>

      <StatsSummary />

      <SalesSection />
    </div>
  )
}

export default Dashboard

