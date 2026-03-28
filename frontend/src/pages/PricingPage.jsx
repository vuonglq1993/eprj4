import React, { useState } from 'react';
import { FiSearch, FiCheck } from 'react-icons/fi';

const pricingDataInit = [
  {
    title: "Free/Personal",
    subtitle: "For a Lifetime",
    price: "Free",
    buttonText: "Current Plan",
    isCurrent: true,
    features: [
      { text: "Unlimited Projects", active: false },
      { text: "Share with 5 team members", active: true },
      { text: "Sync across devices", active: false },
      { text: "API Access", active: true },
      { text: "Complete Documentation", active: false },
      { text: "Integration help", active: true },
    ]
  },
  {
    title: "$89/Professional",
    subtitle: "/year",
    price: "$89",
    buttonText: "Try for free",
    isCurrent: false,
    features: [
      { text: "Everything in free plan", active: false },
      { text: "Unlimited projects", active: true },
      { text: "Share with 5 team members", active: false },
      { text: "30 day version history", active: true },
      { text: "Complete Documentation", active: false },
      { text: "Integration help", active: true },
    ]
  },
  {
    title: "Custom/Enterprise",
    subtitle: "Reach out for a quote",
    price: "Custom",
    buttonText: "Contact Us",
    isCurrent: false,
    features: [
      { text: "Everything in Team plan", active: false },
      { text: "Advanced security", active: true },
      { text: "Custom contract", active: false },
      { text: "User provisioning ( SCIM)", active: true },
      { text: "Complete Documentation", active: false },
      { text: "SAML SSO", active: true },
    ]
  }
];

const PricingPage = () => {

  const [pricingData, setPricingData] = useState(pricingDataInit);

  // ✅ thêm hàm toggle
  const toggleCheck = (planIndex, featureIndex) => {
    const newData = [...pricingData];
    newData[planIndex].features[featureIndex].active =
      !newData[planIndex].features[featureIndex].active;

    setPricingData(newData);
  };

  return (
    <div className="pricing-container">
      <div className="pricing-intro">
        <h2>Pricing</h2>
        <p>Simple Pricing. No Hidden Fees. Advance Features for your business.</p>
      </div>

      <div className="pricing-grid">
        {pricingData.map((plan, index) => (
          <div key={index} className="pricing-card">
            <div className="card-header">
              <h3>{plan.title}</h3>
              <span className="subtitle">{plan.subtitle}</span>
            </div>

            <button className={`plan-btn ${plan.isCurrent ? 'btn-outline' : 'btn-primary'}`}>
              {plan.buttonText}
            </button>

            <ul className="feature-list">
              {plan.features.map((feature, idx) => (
                <li key={idx} className="feature-item">
                  
                  {/* ✅ chỉ thêm onClick vào đây */}
                  <div
                    className={`check-box ${feature.active ? 'active' : ''}`}
                    onClick={() => toggleCheck(index, idx)}
                    style={{ cursor: "pointer" }}
                  >
                    {feature.active && <FiCheck />}
                  </div>

                  <span className="feature-text">{feature.text}</span>
                </li>
              ))}
            </ul>
          </div>
        ))}
      </div>
    </div>
  );
};

export default PricingPage;
