import React from 'react';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  Title,
  Tooltip,
  Legend,
  Filler,
  ArcElement,
} from 'chart.js';
import { Line, Bar, Doughnut } from 'react-chartjs-2';
import { FiSearch, FiHelpCircle } from 'react-icons/fi';
import '../styles/Charts.css';

ChartJS.register(
  CategoryScale, LinearScale, PointElement, LineElement, 
  BarElement, Title, Tooltip, Legend, Filler, ArcElement
);

const ChartsPage = () => {
  const lineData = {
    labels: ['10', '20', '30', '40', '50', '60', '70', '80', '90', '100', '200', '300', '400', '500'],
    datasets: [{
      label: 'Sales',
      data: [12, 18, 15, 25, 20, 28, 22, 20, 15, 14, 20, 10],
      borderColor: '#6366f1',
      backgroundColor: 'rgba(99, 102, 241, 0.2)',
      tension: 0.4,
      pointRadius: 0,
      fill: true,
    }],
  };
  const doughnutData = {
    datasets: [{
      data: [35, 45, 20],
      backgroundColor: ['#6366f1', '#c7d2fe', '#f1f5f9'],
      borderWidth: 0,
      circumference: 180,
      rotation: 270,
    }],
  };

  const barData = {
    labels: ['1', '2', '3', '4', '5', '6', '7'],
    datasets: [
      {
        label: 'Income',
        data: [1200, 500, 800, 800, 1500, 850, 1000],
        backgroundColor: '#6366f1',
        borderRadius: 5,
      },
      {
        label: 'Outcome',
        data: [1000, 1100, 1800, 1400, 1400, 800, 2000],
        backgroundColor: '#c7d2fe',
        borderRadius: 5,
      }
    ],
  };

  return (
    <div className="charts-container">
      <header className="charts-header">
        <div className="header-left">
          <h1>Charts</h1>
          <p>Charts on this page use Chart</p>
        </div>
      </header>


      <div className="charts-grid">
        <div className="chart-card">
          <div className="card-title">
            <span>Line Chart</span>
            <span className="legend-dot">Sales</span>
          </div>
          <Line data={lineData} options={{ responsive: true, plugins: { legend: { display: false } } }} />
        </div>

        <div className="chart-card">
          <div className="card-title">
            <span>Pie Chart</span>
            <FiHelpCircle className="help-icon" />
          </div>
          <div className="doughnut-wrapper">
            <Doughnut data={doughnutData} />
            <div className="doughnut-labels">
              <div className="label-item">
                <span className="dot purple"></span>
                <div><strong>35%</strong><p>Men</p></div>
              </div>
              <div className="label-item">
                <span className="dot light-purple"></span>
                <div><strong>45%</strong><p>Women</p></div>
              </div>
            </div>
          </div>
        </div>
      </div>


      <div className="charts-grid" style={{ marginTop: '30px' }}>
        <div className="chart-card">
          <div className="card-title">
            <div className="bar-info">
              <p>Bar Chart</p>
              <h3>$860,472.29</h3>
            </div>
          </div>
          <Bar data={barData} options={{ scales: { x: { stacked: true }, y: { stacked: true } }, plugins: { legend: { display: false } } }} />
        </div>

        <div className="chart-card">
          <div className="card-title">
            <span>Line Chart Gradient</span>
            <select className="time-select">
              <option>This Month</option>
            </select>
          </div>
          <div className="gradient-chart-placeholder">
             
             <Line data={lineData} />
          </div>
        </div>
      </div>
    </div>
  );
};

export default ChartsPage;