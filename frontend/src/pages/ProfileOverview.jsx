import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { MdHelpOutline, MdPeople, MdSettings, MdExpandMore } from 'react-icons/md'
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  BarChart,
  Bar,
  Cell,
} from 'recharts'
import { useAuth } from '../contexts/AuthContext'
import { getProfile } from '../services/userService'
import '../styles/profile-overview.css'

const interactionData = [
  { date: '25.02', red: 20, blue: 15, lightBlue: 10 },
  { date: '26.02', red: 180, blue: 120, lightBlue: 80 },
  { date: '27.02', red: 100, blue: 200, lightBlue: 150 },
  { date: '28.02', red: 50, blue: 180, lightBlue: 100 },
  { date: '29.02', red: 30, blue: 40, lightBlue: 20 },
]

const bestTimeData = [
  { day: 'Mon', value: 85, highlight: false },
  { day: 'Tue', value: 35, highlight: false },
  { day: 'Wed', value: 55, highlight: false },
  { day: 'Thu', value: 45, highlight: false },
  { day: 'Fri', value: 95, highlight: true },
  { day: 'Sat', value: 30, highlight: false },
  { day: 'Sun', value: 60, highlight: false },
]

const ageRangeData = [
  { range: '13-17', men: 40, women: 35 },
  { range: '18-24', men: 70, women: 65 },
  { range: '25-34', men: 85, women: 80 },
  { range: '35-44', men: 75, women: 70 },
  { range: '45-54', men: 95, women: 90 },
  { range: '55-64', men: 25, women: 55 },
  { range: '65-74+', men: 30, women: 40 },
]

const kpiCards = [
  {
    label: 'Average Likes',
    value: '635',
    trend: '+21.01%',
    trendUp: true,
    color: 'purple',
    sparkData: [30, 45, 35, 55, 40, 60, 50, 70, 55, 65],
  },
  {
    label: 'Comments recived',
    value: '123',
    trend: '+4.399%',
    trendUp: true,
    color: 'green',
    sparkData: [20, 35, 25, 50, 40, 45, 55, 50, 60, 55],
  },
  {
    label: 'Av. Engagement rate',
    value: '23%',
    trend: '-7.9%',
    trendUp: false,
    color: 'blue',
    sparkData: [70, 60, 75, 55, 65, 50, 60, 45, 55, 50],
  },
]

const actionsList = [
  { label: 'Profile visits', value: 250 },
  { label: 'Website clicks', value: 115 },
  { label: 'Calls', value: 67 },
  { label: 'Getvdirection', value: 164 },
  { label: 'Emails', value: 170 },
]

const hashtagSets = [
  { id: 'sport', title: 'Sport & Health', tags: '#sport #fit #health' },
  { id: 'animals', title: 'Animals', tags: '#animal #nature #health' },
  { id: 'beauty', title: 'Beauty', tags: '#beauty #makeup #fashion' },
]

function ProfileOverview() {
  const { user } = useAuth()
  const navigate = useNavigate()
  const [profile, setProfile] = useState(null)
  const [loadingProfile, setLoadingProfile] = useState(true)
  const [bestTimeView, setBestTimeView] = useState('days')
  const [ageRangeFilter, setAgeRangeFilter] = useState('all')
  const [expandedSets, setExpandedSets] = useState(new Set(['sport', 'animals', 'beauty']))

  useEffect(() => {
    getProfile()
      .then((res) => setProfile(res.data))
      .catch(() => {})
      .finally(() => setLoadingProfile(false))
  }, [])

  const toggleSet = (id) => {
    setExpandedSets((prev) => {
      const next = new Set(prev)
      if (next.has(id)) next.delete(id)
      else next.add(id)
      return next
    })
  }

  // Build display name from real user data
  const displayName = profile
    ? `${profile.firstName || ''} ${profile.lastName || ''}`.trim() || profile.email || 'User'
    : user ? `${user.firstName || ''} ${user.lastName || ''}`.trim() || user.email || 'User' : 'User'
  const initials = displayName
    .split(' ')
    .map((w) => w[0])
    .slice(0, 2)
    .join('')
    .toUpperCase() || 'U'
  const avatarSrc = profile?.avatarUrl || user?.avatarUrl || null

  return (
    <div className="profile-overview">
      <div className="profile-overview__body">
        <div className="profile-overview__main">
      {/* Top: 3 KPI cards (mini line + value + trend) */}
      <section className="profile-kpi-row">
        {kpiCards.map((card) => (
          <div key={card.label} className={`profile-kpi-card profile-kpi-card--${card.color}`}>
            <div className="profile-kpi-card__chart">
              <svg viewBox="0 0 120 32" preserveAspectRatio="none" className="profile-kpi-card__spark">
                <polyline
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="1.5"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  points={card.sparkData
                    .map((y, i) => `${(i / (card.sparkData.length - 1)) * 120},${32 - (y / 80) * 28}`)
                    .join(' ')}
                />
              </svg>
            </div>
            <div className="profile-kpi-card__main">
              <span className="profile-kpi-card__value">{card.value}</span>
              <span className={`profile-kpi-card__trend profile-kpi-card__trend--${card.trendUp ? 'up' : 'down'}`}>
                {card.trend}
              </span>
            </div>
            <div className="profile-kpi-card__label">{card.label}</div>
          </div>
        ))}
      </section>

      {/* Followers chart + Actions list */}
      <section className="profile-charts">
        <div className="profile-chart-card">
          <header className="profile-chart-card__header">
            <h3 className="profile-chart-card__title">Followers</h3>
            <div className="profile-chart-card__legend">
              <span className="profile-chart-card__legend-item profile-chart-card__legend-item--red">• Income</span>
              <span className="profile-chart-card__legend-item profile-chart-card__legend-item--purple">• Outcome</span>
            </div>
          </header>
          <div className="profile-chart-card__body profile-chart-card__body--followers">
            <div className="profile-followers-chart" />
          </div>
        </div>

        <div className="profile-chart-card">
          <header className="profile-chart-card__header">
            <h3 className="profile-chart-card__title">Actions</h3>
            <button type="button" className="profile-chart-card__icon-btn" aria-label="Help">
              <MdHelpOutline />
            </button>
          </header>
          <div className="profile-chart-card__body">
            <ul className="profile-actions-list">
              {actionsList.map((item) => (
                <li key={item.label} className="profile-actions-list__item">
                  <span className="profile-actions-list__label">{item.label}</span>
                  <span className="profile-actions-list__value">{item.value}</span>
                </li>
              ))}
            </ul>
          </div>
        </div>
      </section>

      {/* Header */}
      

      {/* Bottom: 2x2 grid - Interaction, Best time, Gender, Age range */}
      <section className="profile-bottom-grid">
        {/* Interaction */}
        <div className="profile-section profile-section--chart">
          <header className="profile-section__header">
            <h3 className="profile-section__title">Interaction</h3>
            <button type="button" className="profile-chart-card__icon-btn" aria-label="Help">
              <MdHelpOutline />
            </button>
          </header>
          <div className="profile-section__chart-wrap">
            <ResponsiveContainer width="100%" height={220}>
              <LineChart data={interactionData} margin={{ top: 8, right: 8, left: 0, bottom: 0 }}>
                <CartesianGrid strokeDasharray="3 3" stroke="#e4e4f0" />
                <XAxis dataKey="date" tick={{ fontSize: 12 }} stroke="#6b7280" />
                <YAxis domain={[0, 250]} ticks={[0, 50, 150, 250]} tick={{ fontSize: 12 }} stroke="#6b7280" />
                <Tooltip />
                <Line type="monotone" dataKey="red" stroke="#dc2626" strokeWidth={2} strokeDasharray="5 5" dot={false} />
                <Line type="monotone" dataKey="blue" stroke="#4f46e5" strokeWidth={2} strokeDasharray="5 5" dot={false} />
                <Line type="monotone" dataKey="lightBlue" stroke="#818cf8" strokeWidth={2} strokeDasharray="5 5" dot={false} />
              </LineChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* Best time */}
        <div className="profile-section profile-section--chart">
          <header className="profile-section__header">
            <h3 className="profile-section__title">Best time</h3>
            <div className="profile-section__toggles">
              <button
                type="button"
                className={`profile-section__toggle ${bestTimeView === 'days' ? 'profile-section__toggle--active' : ''}`}
                onClick={() => setBestTimeView('days')}
              >
                Days
              </button>
              <button
                type="button"
                className={`profile-section__toggle ${bestTimeView === 'hours' ? 'profile-section__toggle--active' : ''}`}
                onClick={() => setBestTimeView('hours')}
              >
                Hours
              </button>
            </div>
            <button type="button" className="profile-chart-card__icon-btn profile-chart-card__icon-btn--after" aria-label="Help">
              <MdHelpOutline />
            </button>
          </header>
          <div className="profile-section__chart-wrap">
            <ResponsiveContainer width="100%" height={220}>
              <BarChart data={bestTimeData} margin={{ top: 8, right: 8, left: 8, bottom: 0 }}>
                <XAxis dataKey="day" tick={{ fontSize: 12 }} stroke="#6b7280" />
                <YAxis tick={{ fontSize: 12 }} stroke="#6b7280" />
                <Bar dataKey="value" radius={[4, 4, 0, 0]}>
                  {bestTimeData.map((entry, index) => (
                    <Cell key={index} fill={entry.highlight ? 'var(--primary)' : '#c7d2fe'} />
                  ))}
                </Bar>
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* Gender */}
        <div className="profile-section profile-section--chart">
          <header className="profile-section__header">
            <h3 className="profile-section__title">Gender</h3>
            <button type="button" className="profile-chart-card__icon-btn" aria-label="Help">
              <MdHelpOutline />
            </button>
          </header>
          <div className="profile-gender-wrap">
            <svg className="profile-gender-arc" viewBox="0 0 200 120" preserveAspectRatio="xMidYMax meet">
              <defs>
                <linearGradient id="genderArc" x1="0%" y1="0%" x2="100%" y2="0%">
                  <stop offset="0%" stopColor="var(--primary)" />
                  <stop offset="39%" stopColor="var(--primary)" />
                  <stop offset="39%" stopColor="#c7d2fe" />
                  <stop offset="100%" stopColor="#c7d2fe" />
                </linearGradient>
              </defs>
              <path
                d="M 20 100 A 90 90 0 0 1 180 100"
                fill="none"
                stroke="url(#genderArc)"
                strokeWidth="24"
                strokeLinecap="round"
              />
              <circle cx="92" cy="78" r="10" fill="#fff" stroke="var(--primary)" strokeWidth="2" />
            </svg>
            <div className="profile-gender-labels">
              <span className="profile-gender-label profile-gender-label--men">35% Men</span>
              <span className="profile-gender-label profile-gender-label--women">45% Women</span>
            </div>
          </div>
        </div>

        {/* Age range */}
        <div className="profile-section profile-section--chart">
          <header className="profile-section__header">
            <h3 className="profile-section__title">Age range</h3>
            <div className="profile-section__toggles">
              <button
                type="button"
                className={`profile-section__toggle ${ageRangeFilter === 'all' ? 'profile-section__toggle--active' : ''}`}
                onClick={() => setAgeRangeFilter('all')}
              >
                All
              </button>
              <button
                type="button"
                className={`profile-section__toggle ${ageRangeFilter === 'men' ? 'profile-section__toggle--active' : ''}`}
                onClick={() => setAgeRangeFilter('men')}
              >
                Men
              </button>
              <button
                type="button"
                className={`profile-section__toggle ${ageRangeFilter === 'women' ? 'profile-section__toggle--active' : ''}`}
                onClick={() => setAgeRangeFilter('women')}
              >
                Women
              </button>
            </div>
            <button type="button" className="profile-chart-card__icon-btn profile-chart-card__icon-btn--after" aria-label="Help">
              <MdHelpOutline />
            </button>
          </header>
          <div className="profile-section__chart-wrap">
            <ResponsiveContainer width="100%" height={220}>
              <BarChart data={ageRangeData} margin={{ top: 8, right: 8, left: 8, bottom: 0 }}>
                <XAxis dataKey="range" tick={{ fontSize: 11 }} stroke="#6b7280" />
                <YAxis tick={{ fontSize: 12 }} stroke="#6b7280" />
                <Bar dataKey="men" fill="var(--primary)" radius={[4, 4, 0, 0]} />
                <Bar dataKey="women" fill="#c7d2fe" radius={[4, 4, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>
      </section>
        </div>

        {/* Right sidebar: My profile */}
        <aside className="profile-overview__sidebar">
          <div className="profile-sidebar-card">
            <header className="profile-sidebar-card__header">
              <h3 className="profile-sidebar-card__title">My profile</h3>
              <div className="profile-sidebar-card__icons">
                <button type="button" className="profile-sidebar-card__icon-btn" aria-label="People">
                  <MdPeople />
                </button>
                <button type="button" className="profile-sidebar-card__icon-btn" aria-label="Settings">
                  <MdSettings />
                </button>
              </div>
            </header>
            <div className="profile-sidebar-card__avatar-wrap">
              <div className="profile-sidebar-card__avatar">
                {avatarSrc ? (
                  <img src={avatarSrc} alt={displayName} style={{ width: '100%', height: '100%', borderRadius: '50%', objectFit: 'cover' }} />
                ) : (
                  initials
                )}
              </div>
              <div className="profile-sidebar-card__name">{displayName}</div>
            </div>
            <div className="profile-sidebar-card__vip">
              <div className="profile-sidebar-card__vip-label">VIP Training Course</div>
              <div className="profile-sidebar-card__vip-row">
                <span className="profile-sidebar-card__vip-pct">10%</span>
                <div className="profile-sidebar-card__vip-bar">
                  <div className="profile-sidebar-card__vip-fill" style={{ width: '10%' }} />
                </div>
              </div>
            </div>
            <div className="profile-sidebar-card__hashtags">
              <div className="profile-sidebar-card__hashtags-head">
                <span className="profile-sidebar-card__hashtags-title">Hashtags sets</span>
                <button type="button" className="profile-sidebar-card__hashtags-gear" aria-label="Settings">
                  <MdSettings />
                </button>
              </div>
              <ul className="profile-sidebar-card__hashtags-list">
                {hashtagSets.map((set) => (
                  <li key={set.id} className="profile-sidebar-card__hashtag-item">
                    <button
                      type="button"
                      className="profile-sidebar-card__hashtag-head"
                      onClick={() => toggleSet(set.id)}
                      aria-expanded={expandedSets.has(set.id)}
                    >
                      <span className="profile-sidebar-card__hashtag-title">{set.title}</span>
                      <MdExpandMore
                        className={`profile-sidebar-card__hashtag-chevron ${expandedSets.has(set.id) ? 'profile-sidebar-card__hashtag-chevron--open' : ''}`}
                        aria-hidden
                      />
                    </button>
                    {expandedSets.has(set.id) && (
                      <p className="profile-sidebar-card__hashtag-tags">{set.tags}</p>
                    )}
                  </li>
                ))}
              </ul>
            </div>
          </div>
        </aside>
      </div>
    </div>
  )
}

export default ProfileOverview

