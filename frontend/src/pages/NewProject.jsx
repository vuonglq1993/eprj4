import React from 'react';
import 'bootstrap/dist/css/bootstrap.min.css';
import { FiUploadCloud } from 'react-icons/fi'; 

import '../styles/NewProject.css'; 

const NewProject = () => {
  return (
    <div className="new-project-bg">
      <div className="container py-5 d-flex justify-content-center">
        <div className="project-card shadow-sm bg-white p-4 rounded-3">

          {/* Header */}
          <div className="header-content mb-5 text-center">
            <h2 className="title-text">New Project</h2>
            <p className="subtitle-text">Create new project</p>
          </div>

          <form>
            {/* Project Name & Title */}
            <div className="row g-4 mb-4">
              <div className="col-md-6">
                <label className="form-label label-bold">Project Name</label>
                <input type="text" className="form-control input-styled" placeholder="Enter project name" />
              </div>
              <div className="col-md-6">
                <label className="form-label label-bold">Project Title</label>
                <input type="text" className="form-control input-styled" placeholder="Enter project title" />
              </div>
            </div>

            {/* Project Tags */}
            <div className="mb-4">
              <label className="form-label label-bold">Project Tags</label>
              <div className="select-wrapper">
                <select className="form-select input-styled select-text-purple">
                  <option>Choice 1</option>
                  <option>Choice 2</option>
                  <option>Choice 3</option>
                </select>
              </div>
            </div>

            {/* Dates Section */}
            <div className="row g-4 mb-4">
              <div className="col-md-6">
                <label className="form-label label-bold">Start Date</label>
                <input type="date" className="form-control input-styled" />
              </div>
              <div className="col-md-6">
                <label className="form-label label-bold">End Date</label>
                <input type="date" className="form-control input-styled" />
              </div>
            </div>

            {/* Upload Area */}
            <div className="mb-5">
              <label className="form-label label-bold mb-3">Starting File</label>
              <div className="upload-container text-center border rounded p-4">
                <input type="file" id="file-input" hidden />
                <label htmlFor="file-input" className="upload-inner w-100 py-5 cursor-pointer">
                  <FiUploadCloud className="upload-icon mb-3" size={40} />
                  <p className="mb-1">
                    <span className="purple-link">Click to upload</span> or drag and drop
                  </p>
                  <span className="file-info">SVG, PNG, JPG or GIF (max 800x400px)</span>
                </label>
              </div>
            </div>

            {/* Buttons */}
            <div className="footer-actions d-flex justify-content-end gap-3">
              <button type="button" className="btn btn-outline-secondary">Cancel</button>
              <button type="submit" className="btn btn-primary">Create Project</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default NewProject;
