import React from 'react';
import '../../styles/dataTablesPages.css';

const EXAMPLE_PLANS = [
  { name: 'FREE', description: 'Gói miễn phí', price: 0, durationDays: 365, isActive: true },
  { name: 'PREMIUM (ví dụ)', description: 'Gói trả phí — giá lấy từ DB', price: 99000, durationDays: 30, isActive: true },
];

export default function SubscriptionPlansPage() {
  return (
    <div className="db-page py-4 px-3">
      <div className="db-inner mx-auto">
        <h2 className="fw-bold mb-4" style={{ fontSize: '1.5rem', color: '#1e293b' }}>subscription_plans</h2>
        <div className="db-card shadow-sm">
          <div className="table-responsive">
            <table className="table db-table mb-0">
              <thead>
                <tr>
                  <th>name</th>
                  <th>description</th>
                  <th>price (VNĐ)</th>
                  <th>duration_days</th>
                  <th>is_active</th>
                </tr>
              </thead>
              <tbody>
                {EXAMPLE_PLANS.map((p) => (
                  <tr key={p.name}>
                    <td>{p.name}</td>
                    <td>{p.description}</td>
                    <td>{p.price.toLocaleString('vi-VN')}</td>
                    <td>{p.durationDays}</td>
                    <td>{p.isActive ? 'true' : 'false'}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}
