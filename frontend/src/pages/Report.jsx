import React from 'react'
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer
} from "recharts"
import 'bootstrap/dist/css/bootstrap.min.css'

const stats = [
  { title: "Payment", value: "$8,098.32" },
  { title: "Loan income", value: "$901,256.01" },
  { title: "Gross amount", value: "$987,256.98" },
  { title: "Jobs create", value: "$564,164.57" }
]

const chartData = [
  { name: "K", value: 180 },
  { name: "J", value: 220 },
  { name: "G", value: 140 },
  { name: "L", value: 90 },
  { name: "M", value: 40 },
  { name: "P", value: 110 },
  { name: "T", value: 180 },
  { name: "C", value: 90 },
  { name: "H", value: 105 },
  { name: "D", value: 180 },
  { name: "S", value: 220 },
  { name: "W", value: 180 },
  { name: "B", value: 230 },
  { name: "F", value: 290 },
  { name: "A", value: 180 },
  { name: "R", value: 310 }
]

const reportData = [
  {
    title: "Payments",
    total: "$7,124.80",
    data: [
      { date: "1Nov", value1: 2, value2: 0.5 },
      { date: "5Nov", value1: 4, value2: 1 },
      { date: "10Nov", value1: 3, value2: 0.8 },
      { date: "15Nov", value1: 4, value2: 1 },
      { date: "20Nov", value1: 2.5, value2: 0.6 },
      { date: "25Nov", value1: 1, value2: 0.3 }
    ]
  },
  {
    title: "Loan income",
    total: "$860,472.29",
    data: [
      { date: "5Nov", value1: 1200, value2: 900, value3: 400 },
      { date: "10Nov", value1: 500, value2: 800, value3: 900 },
      { date: "15Nov", value1: 800, value2: 700, value3: 600 },
      { date: "20Nov", value1: 1500, value2: 800, value3: 600 },
      { date: "25Nov", value1: 900, value2: 700, value3: 400 }
    ]
  }
]

export default function Report() {
  return (
    <div className="container my-4">

      {}
      <div className="row mb-4">
        {stats.map((item, idx) => (
          <div key={idx} className="col-6 col-md-3 mb-3">
            <div className="card shadow-sm text-center p-3 h-100">
              <h2 className="mb-1">{item.value}</h2>
              <p className="text-muted mb-0">{item.title}</p>
            </div>
          </div>
        ))}
      </div>

      {}
      <div className="card shadow-sm mb-4 p-4">
        <div className="d-flex justify-content-between align-items-center mb-3">
          <p className="text-uppercase text-muted mb-0" style={{ fontSize: '12px', letterSpacing: '0.5px' }}>Statistics</p>
          <h2 className="mb-0">Sales Closed</h2>
        </div>
        <ResponsiveContainer width="100%" height={300}>
          <BarChart data={chartData}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="name" />
            <YAxis />
            <Tooltip />
            <Bar dataKey="value" fill="#7c5cff" radius={[10,10,0,0]} />
          </BarChart>
        </ResponsiveContainer>
      </div>

      
      <div className="row">
        {reportData.map((card, index) => (
          <div key={index} className="col-12 col-md-6 mb-4">
            <div className="card shadow-sm p-4 h-100">
              <div className="d-flex justify-content-between align-items-center mb-3">
                <p className="text-uppercase text-muted mb-0" style={{ fontSize: '12px', letterSpacing: '0.5px' }}>{card.title}</p>
                <h2 className="mb-0">{card.total}</h2>
              </div>
              <ResponsiveContainer width="100%" height={250}>
                <BarChart data={card.data} margin={{ top: 10, right: 20, left: 0, bottom: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="date" />
                  <YAxis />
                  <Tooltip />
                  {Object.keys(card.data[0])
                    .filter(k => k !== "date")
                    .map((key, idx2) => (
                      <Bar
                        key={key}
                        dataKey={key}
                        stackId="a"
                        fill={['#7c5cff', '#b497ff', '#d3c5ff'][idx2]}
                        radius={[6,6,0,0]}
                      />
                    ))}
                </BarChart>
              </ResponsiveContainer>
            </div>
          </div>
        ))}
      </div>

    </div>
  )
}
