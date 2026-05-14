import { useEffect, useState } from 'react'
import ActiveUsersCard from '../components/dashboard/ActiveUsersCard.jsx'
import StatsSummary from '../components/dashboard/StatsSummary.jsx'
import EarningsSummary from '../components/dashboard/EarningsSummary.jsx'
import SalesSection from '../components/dashboard/SalesSection.jsx'
import {
  getDashboard,
  getAdminDailyActive,
  getAdminSubscriptionBreakdown,
  getTopLeaderboard,
} from '../services/progressService.js'

function Dashboard() {
  const [stats, setStats]          = useState(null)
  const [dailyActive, setDailyActive]   = useState(null)
  const [subBreakdown, setSubBreakdown] = useState(null)
  const [leaderboard, setLeaderboard]   = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError]     = useState('')

  useEffect(() => {
    Promise.all([
      getDashboard(),
      getAdminDailyActive(7),
      getAdminSubscriptionBreakdown(),
      getTopLeaderboard(5),
    ])
      .then(([dash, daily, sub, lb]) => {
        const base = dash?.data ?? {}
        const premiumUsers = sub != null
          ? (sub.monthly ?? 0) + (sub.threeMonths ?? 0) + (sub.yearly ?? 0)
          : null
        setStats({ ...base, premiumUsers })
        setDailyActive(daily)
        setSubBreakdown(sub)
        setLeaderboard(lb ?? [])
      })
      .catch(() => setError('Không tải được dữ liệu dashboard.'))
      .finally(() => setLoading(false))
  }, [])

  if (loading) {
    return (
      <div className="dashboard">
        <div style={{ display: 'flex', flexDirection: 'column', gap: 20, padding: 24 }}>
          {[1, 2, 3, 4].map((i) => (
            <div key={i} style={{ height: i === 1 ? 200 : i === 2 ? 120 : 280, background: '#f1f5f9', borderRadius: 16, animation: 'pulse 1.5s infinite' }} />
          ))}
        </div>
      </div>
    )
  }

  if (error) {
    return (
      <div className="dashboard" style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', minHeight: 400 }}>
        <div style={{ textAlign: 'center', color: '#94a3b8' }}>
          <p style={{ margin: '0 0 12px', fontSize: 15 }}>{error}</p>
          <button
            type="button"
            onClick={() => window.location.reload()}
            style={{ padding: '8px 20px', background: '#6366f1', color: '#fff', border: 'none', borderRadius: 8, cursor: 'pointer', fontSize: 14 }}
          >
            Thử lại
          </button>
        </div>
      </div>
    )
  }

  return (
    <div className="dashboard">
      <section className="dashboard-section dashboard-section--top">
        <div className="dashboard-grid dashboard-grid--top">
          <ActiveUsersCard dailyActive={dailyActive} />
          <EarningsSummary subBreakdown={subBreakdown} />
        </div>
      </section>

      <StatsSummary data={stats} />

      <SalesSection dailyActive={dailyActive} leaderboard={leaderboard} />
    </div>
  )
}

export default Dashboard
