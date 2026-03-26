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
  { day: 10, value: 45000 },
  { day: 11, value: 52000 },
  { day: 12, value: 58000 },
  { day: 13, value: 62000 },
  { day: 14, value: 71000 },
  { day: 15, value: 75000 },
  { day: 16, value: 78000 },
  { day: 17, value: 80234 },
  { day: 18, value: 85000 },
  { day: 19, value: 88000 },
  { day: 20, value: 92000 },
  { day: 21, value: 95000 },
  { day: 22, value: 98000 },
  { day: 23, value: 95000 },
  { day: 24, value: 90000 },
  { day: 25, value: 85000 },
]

function SalesFunnelChart() {
  const [period, setPeriod] = useState('This Month')

  return (
    <article className="analytics-card analytics-card--chart">
      <div className="analytics-card__header">
        <h3 className="analytics-card__title">Sales Funnel</h3>
        <div className="analytics-card__select-wrap">
          <button type="button" className="analytics-card__select-btn">
            {period}
            <span className="analytics-card__select-arrow">▼</span>
          </button>
        </div>
      </div>
      <div className="analytics-chart-wrap">
        <ResponsiveContainer width="100%" height={260}>
          <AreaChart data={data} margin={{ top: 10, right: 10, left: 0, bottom: 0 }}>
            <defs>
              <linearGradient id="salesGradient" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor="#8b5cf6" stopOpacity={0.4} />
                <stop offset="100%" stopColor="#8b5cf6" stopOpacity={0.05} />
              </linearGradient>
            </defs>
            <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" vertical={false} />
            <XAxis
              dataKey="day"
              axisLine={false}
              tickLine={false}
              tick={{ fill: '#9ca3af', fontSize: 12 }}
              tickFormatter={(v) => String(v)}
            />
            <YAxis
              axisLine={false}
              tickLine={false}
              tick={{ fill: '#9ca3af', fontSize: 12 }}
              tickFormatter={(v) => `${v / 1000}K`}
              domain={[40000, 100000]}
            />
            <Tooltip
              contentStyle={{
                background: '#6c4ef6',
                border: 'none',
                borderRadius: 8,
                color: '#fff',
                fontSize: 13,
                fontWeight: 600,
              }}
              formatter={(value) => [value?.toLocaleString(), '']}
              labelFormatter={(label) => `Day ${label}`}
            />
            <Area
              type="monotone"
              dataKey="value"
              stroke="#6c4ef6"
              strokeWidth={2}
              fill="url(#salesGradient)"
            />
          </AreaChart>
        </ResponsiveContainer>
      </div>
    </article>
  )
}

export default SalesFunnelChart
