import React from 'react';
import { FiSearch, FiDownload, FiMoreVertical } from 'react-icons/fi';
import { FaCcVisa } from 'react-icons/fa';

const Billing = () => {
  const billingData = [
    { id: '#780-Dec 2022', date: 'Dec 23, 2022', amount: 'USD $12.00', plan: 'Basic plan', users: '15 Users', status: 'Paid' },
    { id: '#345-Nov 2022', date: 'Nov 12, 2022', amount: 'USD $22.00', plan: 'Basic plan', users: '56 Users', status: 'Paid' },
    { id: '#213-Oct 2022', date: 'Oct 09, 2022', amount: 'USD $80.00', plan: 'Basic plan', users: '90 Users', status: 'Paid' },
    { id: '#324-Agu 2022', date: 'Agu 03, 2022', amount: 'USD $12.00', plan: 'Basic plan', users: '22 Users', status: 'Paid' },
    { id: '#123-July 2022', date: 'July 13, 2022', amount: 'USD $67.00', plan: 'Basic plan', users: '23 Users', status: 'Paid' },
  ];

  return (
    <div className="billing-page">
      <section className="plans-section">
        <h2>Plans and billing</h2>
        <p className="subtitle">Manage your plan and billing details</p>
        
        <div className="plans-grid">
          {/* Card gói cước */}
          <div className="billing-card basic-plan-card">
            <div className="plan-info">
              <h3>Basic plan</h3>
              <p>Our most popular plan for small teams.</p>
              <div className="user-avatars">
                <img src="https://i.pravatar.cc/150?u=1" alt="user" />
                <img src="https://i.pravatar.cc/150?u=2" alt="user" />
                <img src="https://i.pravatar.cc/150?u=3" alt="user" />
                <img src="https://i.pravatar.cc/150?u=4" alt="user" />
              </div>
            </div>
            <div className="plan-price">
              <span className="amount">$20</span>
              <span className="period">per month</span>
            </div>
            <div className="card-footer">
              <button className="text-btn">Upgrade plan <span>▼</span></button>
            </div>
          </div>

          {/* Card phương thức thanh toán */}
          <div className="billing-card payment-method-card">
            <h3>Payment method</h3>
            <p>Change how you pay for your plan.</p>
            <div className="visa-box">
              <div className="visa-info">
                <FaCcVisa className="visa-icon" />
                <div>
                  <p className="visa-name">Visa ending in 6789</p>
                  <p className="visa-expiry">Expiry 01/2023</p>
                </div>
              </div>
              <button className="edit-btn">Edit</button>
            </div>
          </div>
        </div>
      </section>

      <section className="history-section">
        <div className="history-header">
          <div>
            <h2>Billing history</h2>
            <p className="subtitle">Download your previous plan receipts and usage details.</p>
          </div>
          <button className="download-all-btn">Download all</button>
        </div>

        <div className="history-table-container">
          <table className="billing-table">
            <thead>
              <tr>               
                <th>Billing</th>
                <th>Status</th>
                <th>Billing Date</th>
                <th>Amount</th>
                <th>Plan</th>
                <th>Users</th>
                <th></th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {billingData.map((item, index) => (
                <tr key={index}>
                  <td><input type="checkbox" defaultChecked={index % 2 === 0} /></td>
                  <td className="billing-id">
                    <FiDownload className="pdf-icon" /> Billing {item.id}
                  </td>
                  <td><span className="status-tag">{item.status}</span></td>
                  <td>{item.date}</td>
                  <td>{item.amount}</td>
                  <td>{item.plan}</td>
                  <td>{item.users}</td>
                  <td><button className="download-row-btn">Download all</button></td>
                  <td><FiMoreVertical className="more-icon" /></td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>
    </div>
  );
};

export default Billing;