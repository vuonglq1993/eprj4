import { useState } from 'react'
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  Area,
  AreaChart,
} from 'recharts'

const data = [
  { date: 'May 5', green: 180, orange: 120 },
  { date: 'May 6', green: 220, orange: 150 },
  { date: 'May 7', green: 260, orange: 180 },
  { date: 'May 8', green: 300, orange: 220 },
  { date: 'May 9', green: 340, orange: 250 },
  { date: 'May 10', green: 320, orange: 240 },
  { date: 'May 11', green: 350, orange: 260 },
  { date: 'May 12', green: 380, orange: 290 },
  { date: 'May 13', green: 360, orange: 270 },
  { date: 'May 14', green: 390, orange: 300 },
  { date: 'May 15', green: 400, orange: 310 },
]

function WatchlistsChart() {
  const [range, setRange] = useState('Day')

  return (
    <article className="analytics-card analytics-card--chart">
      <div className="analytics-card__header">
        <h3 className="analytics-card__title">Watchlists</h3>
        <div className="analytics-range-tabs">
          {['Day', 'Week', 'Month'].map((r) => (
            <button
              key={r}
              type="button"
              className={`analytics-range-tab ${range === r ? 'analytics-range-tab--active' : ''}`}
              onClick={() => setRange(r)}
            >
              {r}
            </button>
          ))}
        </div>
      </div>
      <div className="analytics-chart-wrap">
        <ResponsiveContainer width="100%" height={260}>
          <AreaChart data={data} margin={{ top: 10, right: 10, left: 0, bottom: 0 }}>
            <defs>
              <linearGradient id="greenGrad" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor="#22c55e" stopOpacity={0.35} />
                <stop offset="100%" stopColor="#22c55e" stopOpacity={0.02} />
              </linearGradient>
              <linearGradient id="orangeGrad" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor="#f59e0b" stopOpacity={0.35} />
                <stop offset="100%" stopColor="#f59e0b" stopOpacity={0.02} />
              </linearGradient>
            </defs>
            <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" vertical={false} />
            <XAxis
              dataKey="date"
              axisLine={false}
              tickLine={false}
              tick={{ fill: '#9ca3af', fontSize: 12 }}
            />
            <YAxis
              axisLine={false}
              tickLine={false}
              tick={{ fill: '#9ca3af', fontSize: 12 }}
              domain={[0, 400]}
            />
            <Tooltip
              contentStyle={{
                background: '#22c55e',
                border: 'none',
                borderRadius: 8,
                color: '#fff',
                fontSize: 13,
                fontWeight: 600,
              }}
              formatter={(value) => [value, '']}
            />
            <Area
              type="monotone"
              dataKey="green"
              stroke="#22c55e"
              strokeWidth={2}
              fill="url(#greenGrad)"
            />
            <Area
              type="monotone"
              dataKey="orange"
              stroke="#f59e0b"
              strokeWidth={2}
              fill="url(#orangeGrad)"
            />
          </AreaChart>
        </ResponsiveContainer>
      </div>
    </article>
  )
}

export default WatchlistsChart
