import React from 'react';
import '../styles/setting.css'
const Setting = () => {
  return (
    <div className="setting-container">
      {/* Header */}
      <div className="setting-header">
        <div className="header-info">
          <h1>Setting Details</h1>
          <p>Update your photo and personal details here.</p>
        </div>
        <div className="header-actions">
          <button className="btn-cancel">Cancel</button>
          <button className="btn-save">Save</button>
        </div>
      </div>

      <div className="setting-content">
        {/* Cột trái: Form */}
        <div className="card form-card">
          <h2 className="card-title">Personal information</h2>
          <div className="form-grid">
            <div className="input-group">
              <label>Full Name</label>
              <input type="text" placeholder="Enter first name" />
            </div>
            <div className="input-group">
              <label>Last Name</label>
              <input type="text" placeholder="Enter last name" />
            </div>
            <div className="input-group">
              <label>Email Address</label>
              <input type="email" placeholder="Enter email address" />
            </div>
            <div className="input-group">
              <label>Username</label>
              <input type="text" placeholder="Enter user name" />
            </div>
            <div className="input-group">
              <label>Phone No</label>
              <input type="text" placeholder="Enter phone no" />
            </div>
            <div className="input-group">
              <label>City</label>
              <input type="text" placeholder="Enter your city" />
            </div>
            <div className="input-group">
              <label>Country Name</label>
              <input type="text" placeholder="Enter country name" />
            </div>
            <div className="input-group">
              <label>Zip code</label>
              <input type="text" placeholder="Enter zip code" />
            </div>
          </div>
          <div className="input-group full-width">
            <label>Bio (Short introduction)</label>
            <textarea rows="4" placeholder="Tell us about yourself..."></textarea>
          </div>
          <div className="input-group" style={{marginTop : '22px'}}>
            <label>Timezone</label>
            <input type="text" placeholder="Paciftc Standard Time" />
          </div>
        </div>
        
        <div className="side-column">
          <div className="card photo-card">
            <h2 className="card-title">Your Photo</h2>
            <div className="photo-edit">
              <img src="https://i.pravatar.cc/150" alt="Avatar" className="avatar" />
              <div className="photo-controls">
                <p>Edit your photo</p>
                <button className="text-delete">Delete</button>
                <button className="text-update">Update</button>
              </div>
            </div>

            <div className="upload-box">
              <div className="upload-icon">↑</div>
              <p><span>Click to upload</span> or drag and drop</p>
              <small>SVG, PNG, JPG (Max 800x400px)</small>
            </div>
          </div>

          <div className="card google-card">
            <div className="google-header">
              <span className="google-logo">Google</span>
              <span className="status-badge">Connected</span>
            </div>
            <p>Use Google to sign in to your account. <a href="#">Learn more</a></p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Setting;