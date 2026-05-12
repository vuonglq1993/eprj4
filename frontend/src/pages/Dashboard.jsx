import { useEffect, useState } from 'react'
import ActiveUsersCard from '../components/dashboard/ActiveUsersCard.jsx'
import StatsSummary from '../components/dashboard/StatsSummary.jsx'
import EarningsSummary from '../components/dashboard/EarningsSummary.jsx'
import SalesSection from '../components/dashboard/SalesSection.jsx'
import { getDashboard } from '../services/progressService.js'

function Dashboard() {
  const [data, setData] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    getDashboard()
      .then((res) => setData(res.data))
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
          <ActiveUsersCard data={data} />
          <EarningsSummary data={data} />
        </div>
      </section>

      <StatsSummary data={data} />

      <SalesSection data={data} />
    </div>
  )
}

export default Dashboard
