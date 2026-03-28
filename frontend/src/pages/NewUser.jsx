import React, { useState } from 'react';
import { FiSearch } from 'react-icons/fi';
const NewUser = () => {
  const [activeStep, setActiveStep] = useState(1);

  const handleNext = () => {
    if (activeStep < 4) {
      setActiveStep(activeStep + 1);
    }
  };

  const renderFormContent = () => {
    switch (activeStep) {
      case 1:
        return (
          <div className="form-grid">
            <div className="input-group"><label>First name</label><input type="text" placeholder="eg. Malik" /></div>
            <div className="input-group"><label>Last Name</label><input type="text" placeholder="eg. Ali" /></div>
            <div className="input-group"><label>Company</label><input type="text" placeholder="eg. TeamUXD" /></div>
            <div className="input-group"><label>Email Address</label><input type="email" placeholder="eg. Team@gmail.com" /></div>
            <div className="input-group"><label>Password</label><input type="password" placeholder="********" /></div>
            <div className="input-group"><label>Repeat password</label><input type="password" placeholder="********" /></div>
          </div>
        );
      case 2:
        return (
          <div className="form-grid">
            <div className="input-group"><label>Address 1</label><input type="text" placeholder="Street 1" /></div>
            <div className="input-group"><label>City</label><input type="text" placeholder="eg. Hanoi" /></div>
            <div className="input-group"><label>Zip code</label><input type="text" placeholder="eg. 10000" /></div>
          </div>
        );
      case 3:
        return (
          <div className="form-grid">
            <div className="input-group"><label>Facebook Profile</label><input type="text" placeholder="https://facebook.com/..." /></div>
            <div className="input-group"><label>LinkedIn</label><input type="text" placeholder="https://linkedin.com/..." /></div>
          </div>
        );
      default:
        return <div className="success-msg">All steps completed! Ready to create profile.</div>;
    }
  };

  return (
    <div className="new-user-page">
      <div className="content-container">
        {/* Stepper logic */}
        <div className="stepper-card">
          <div className="stepper">
            {[
              { id: 1, label: "User Info" },
              { id: 2, label: "Address" },
              { id: 3, label: "Socials" },
              { id: 4, label: "Profile" }
            ].map((step, index, arr) => (
              <React.Fragment key={step.id}>
                <div className={`step ${activeStep >= step.id ? 'active' : ''}`}>
                  <div className="circle"></div>
                  <span>{step.label}</span>
                </div>
                {index !== arr.length - 1 && (
                  <div className={`line ${activeStep > step.id ? 'active' : ''}`}></div>
                )}
              </React.Fragment>
            ))}
          </div>
        </div>

        {/* Form Content */}
        <div className="form-card">
          <div className="form-header">
            <h2>{activeStep === 1 ? "About me" : activeStep === 2 ? "Address Details" : "Finalize"}</h2>
            <p>Mandatory information</p>
          </div>

          {renderFormContent()}

          <div className="form-footer">
            {activeStep > 1 && (
              <button className="btn-prev" onClick={() => setActiveStep(activeStep - 1)}>Back</button>
            )}
            <button className="btn-next" onClick={handleNext}>
              {activeStep === 4 ? "Finish" : "Next"}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default NewUser;