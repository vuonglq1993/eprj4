import React, { useState } from 'react';
import { FiEdit2, FiCheck, FiArrowRight, FiSend } from 'react-icons/fi';

const Wizard = () => {
  const [currentStep, setCurrentStep] = useState(1);
  const steps = [
    { id: 1, label: 'About' },
    { id: 2, label: 'Account' },
    { id: 3, label: 'Address' }
  ];

  const nextStep = () => currentStep < 3 && setCurrentStep(currentStep + 1);
  const prevStep = () => currentStep > 1 && setCurrentStep(currentStep - 1);

  return (
    <div className="wizard-container">
      <div className="wizard-header d-flex justify-content-center align-items-center mb-5">
        {steps.map((step, index) => (
          <React.Fragment key={step.id}>
            <div className={`step-item ${currentStep >= step.id ? 'active' : ''}`}>
              <div className="step-number">{currentStep > step.id ? <FiCheck /> : step.id}</div>
              <span className="step-label">{step.label}</span>
            </div>
            {index < steps.length - 1 && (
              <div className={`step-line ${currentStep > step.id ? 'active' : ''}`}></div>
            )}
          </React.Fragment>
        ))}
      </div>
      <div className="wizard-card shadow-sm p-5">
        {currentStep === 1 && <StepAbout />}
        {currentStep === 2 && <StepAccount />}
        {currentStep === 3 && <StepAddress />}

        <div className="d-flex justify-content-end mt-4">
          {currentStep < 3 ? (
            <button className="btn-wizard-next" onClick={nextStep}>
              Next <FiArrowRight className="ms-2" />
            </button>
          ) : (
            <button className="btn-wizard-send" onClick={() => alert('Đã gửi thành công!')}>
              Send <FiSend className="ms-2" />
            </button>
          )}
        </div>
      </div>
    </div>
  );
};


const StepAbout = () => (
  <div className="step-content animate-fade-in text-center">
    <h3 className="fw-bold">Let’s start with the basic information</h3>
    <p className="text-muted mb-4">Let us know your name and email address. Use an address you don't mind other users contact you at</p>
    
    <div className="profile-photo-wrapper mb-4">
      <img src="https://i.pravatar.cc/150?u=kame" alt="avatar" className="wizard-avatar" />
      <div className="edit-icon-badge"><FiEdit2 size={12} /></div>
    </div>

    <div className="row g-3 text-start">
      <div className="col-md-6">
        <label className="form-label small fw-bold">First name</label>
        <input type="text" className="form-control wizard-input" placeholder="Kame" />
      </div>
      <div className="col-md-6">
        <label className="form-label small fw-bold">Last name</label>
        <input type="text" className="form-control wizard-input" placeholder="Williamson" />
      </div>
      <div className="col-md-6">
        <label className="form-label small fw-bold">Email Address</label>
        <input type="email" className="form-control wizard-input" placeholder="kamewilliamson@gmail.com" />
      </div>
      <div className="col-md-6">
        <label className="form-label small fw-bold">Date of Birth</label>
        <input type="text" className="form-control wizard-input" placeholder="25/01/2001" />
      </div>
    </div>
  </div>
);

const StepAccount = () => {
  const options = ['Design', 'Develop', 'Code', 'Design', 'Develop', 'Code'];
  const [selectedIdx, setSelectedIdx] = useState(null); // lưu index thay vì tên

  const selectItem = (idx) => {
    if (selectedIdx === idx) {
      setSelectedIdx(null); // bỏ chọn nếu click lại
    } else {
      setSelectedIdx(idx);  // chọn 1 ô duy nhất
    }
  };

  return (
    <div className="step-content animate-fade-in text-center">
      <h3 className="fw-bold">What are you doing? (checkboxes)</h3>
      <p className="text-muted mb-4">
        Give us more detail about you. What do you enjoy doing in your spare time?
      </p>

      <div className="row g-3">
        {options.map((item, idx) => (
          <div className="col-4" key={idx}>
            <div
              className={`selection-box ${selectedIdx === idx ? 'selected' : ''}`}
              onClick={() => selectItem(idx)}
              style={{ cursor: 'pointer' }}
            >
              <div className="box-icon">👥</div>
              <div className="box-text fw-bold">{item}</div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};



const StepAddress = () => (
  <div className="step-content animate-fade-in text-center">
    <h3 className="fw-bold">Are you living in nice area?</h3>
    <p className="text-muted mb-4">One thing I love about the later sunsets is the chance to go for a walk through the neighborhood woods before dinner</p>
    
    <div className="row g-3 text-start">
      <div className="col-md-8">
        <label className="form-label small fw-bold">Street name</label>
        <input type="text" className="form-control wizard-input" placeholder="Soft" />
      </div>
      <div className="col-md-4">
        <label className="form-label small fw-bold">Street no</label>
        <input type="text" className="form-control wizard-input" placeholder="197" />
      </div>
      <div className="col-md-6">
        <label className="form-label small fw-bold">City</label>
        <input type="text" className="form-control wizard-input" placeholder="Berlin" />
      </div>
      <div className="col-md-6">
        <label className="form-label small fw-bold">Country</label>
        <select className="form-select wizard-input">
          <option>Germany</option>
          <option>Vietnam</option>
        </select>
      </div>
    </div>
  </div>
);

export default Wizard;