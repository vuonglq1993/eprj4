import React, { useState } from 'react';
import { FiSearch, FiChevronDown, FiChevronUp, FiCheck, FiPlus } from 'react-icons/fi';
import { FaCcVisa, FaCcPaypal } from 'react-icons/fa';

const Invoice = () => {
  const [selectedPayment, setSelectedPayment] = useState('visa'); // default: Visa

  return (
    <div className="invoice-container">
      <div className="payment-details-section">
        <h2 className="section-main-title mb-4">Payment Details</h2>

        {/* Payment Dropdown */}
        <div className="accordion-item-custom active-shadow shadow-sm">
          <div className="d-flex justify-content-between align-items-center p-4 border-bottom">
            <span className="accordion-title">Payment</span>
            <FiChevronUp className="text-muted" />
          </div>

          <div className="p-4">
            <h6 className="method-label mb-3">Payment method</h6>
            <div className="d-flex gap-3 mb-4">
              {/* Visa Option */}
              <div
                className={`payment-card-option ${selectedPayment === 'visa' ? 'selected' : ''}`}
                onClick={() => setSelectedPayment('visa')}
              >
                <div className="d-flex align-items-center gap-3">
                  <div className="check-box-ui">
                    {selectedPayment === 'visa' && <FiCheck className="check-icon" />}
                  </div>
                  <div className="card-info-ui">
                    <span className="card-number">347809</span>
                    <span className="card-subtext">Visa <a href="#edit">Edit</a></span>
                  </div>
                </div>
                <FaCcVisa className="visa-logo" />
              </div>

              {/* Paypal Option */}
              <div
                className={`payment-card-option ${selectedPayment === 'paypal' ? 'selected' : ''}`}
                onClick={() => setSelectedPayment('paypal')}
              >
                <div className="d-flex align-items-center gap-3">
                  <div className="check-box-ui">
                    {selectedPayment === 'paypal' && <FiCheck className="check-icon" />}
                  </div>
                  <div className="card-info-ui">
                    <span className="card-number">347809</span>
                    <span className="card-subtext">Paypal <a href="#edit">Edit</a></span>
                  </div>
                </div>
                <FaCcPaypal className="paypal-logo" />
              </div>

              {/* New Users Option */}
              <div
                className={`add-method-card ${selectedPayment === 'new' ? 'selected' : ''}`}
                onClick={() => setSelectedPayment('new')}
              >
                <div className="add-icon-wrapper">
                  {selectedPayment === 'new' ? <FiCheck /> : <FiPlus />}
                </div>
                <span className="add-text">New users</span>
              </div>
            </div>

            {/* Form */}
            <form className="row g-4">
              <div className="col-12">
                <label className="custom-label">Card holder name</label>
                <input type="text" className="custom-input" defaultValue="John Walden" />
              </div>
              <div className="col-12">
                <label className="custom-label">Billing address</label>
                <div className="position-relative">
                  <select className="custom-input appearance-none">
                    <option>Germany</option>
                  </select>
                  <FiChevronDown className="select-arrow" />
                </div>
              </div>
              <div className="col-md-6">
                <label className="custom-label">Zip code</label>
                <input type="text" className="custom-input" defaultValue="6789123" />
              </div>
              <div className="col-md-6">
                <label className="custom-label">City</label>
                <input type="text" className="custom-input" defaultValue="Berlin" />
              </div>
              <div className="col-12">
                <div className="d-flex align-items-center gap-2">
                  <input type="checkbox" id="inv-addr" className="custom-check" defaultChecked />
                  <label htmlFor="inv-addr" className="text-muted small mb-0">
                    Invoice Address
                  </label>
                </div>
              </div>
              <div className="col-12 mt-4">
                <button type="button" className="btn-pay-full">
                  Pay $67.00
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Invoice;
