import React from 'react';
import '../styles/editproduct.css';
import { FiUploadCloud, FiChevronDown, FiX, FiPlus } from 'react-icons/fi';

const EditProduct = () => (
  <div className="edit-product-page py-4 px-3">
    <div className="edit-product-inner mx-auto">
      <div className="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
        <div>
          <h2 className="fw-bold mb-1">Edit Product</h2>
          <p className="text-muted small mb-0">Update your product details</p>
        </div>
        <div className="d-flex gap-2">
          <button type="button" className="btn btn-outline-secondary px-4">
            Discard
          </button>
          <button
            type="button"
            className="btn btn-primary-purple px-4"
            onClick={() => window.alert('Changes saved (demo).')}
          >
            Save Changes
          </button>
        </div>
      </div>

      <div className="ep-section-stack">
        <section className="form-section shadow-sm ep-card p-4 p-md-5">
          <ProductInfoForm />
        </section>
        <section className="form-section shadow-sm ep-card p-4 p-md-5">
          <MediaForm />
        </section>
        <section className="form-section shadow-sm ep-card p-4 p-md-5">
          <SocialForm />
        </section>
        <section className="form-section shadow-sm ep-card p-4 p-md-5">
          <PricingForm />
        </section>
      </div>
    </div>
  </div>
);

const ProductInfoForm = () => (
  <div className="ep-section-panel">
    <h5 className="fw-bold text-center mb-4">Product Information</h5>
    <form className="row g-3">
      <div className="col-md-6">
        <label className="form-label small fw-semibold">Name</label>
        <input type="text" className="form-control custom-input" defaultValue="Off - White" />
      </div>
      <div className="col-md-6">
        <label className="form-label small fw-semibold">Weight</label>
        <input type="number" className="form-control custom-input" defaultValue="42" />
      </div>
      <div className="col-md-6">
        <label className="form-label small fw-semibold">Sizes</label>
        <div className="position-relative">
          <select className="form-select custom-input">
            <option>Large</option>
            <option>Medium</option>
            <option>Small</option>
          </select>
          <FiChevronDown size={18} className="ep-select-arrow" aria-hidden />
        </div>
      </div>
      <div className="col-md-6">
        <label className="form-label small fw-semibold">Category</label>
        <div className="position-relative">
          <select className="form-select custom-input">
            <option>Clothing</option>
            <option>Footwear</option>
          </select>
          <FiChevronDown size={18} className="ep-select-arrow" aria-hidden />
        </div>
      </div>
      <div className="col-12">
        <label className="form-label small fw-semibold">Description</label>
        <textarea className="form-control custom-input" rows={4} defaultValue="Some initial bold text" />
      </div>
    </form>
  </div>
);

const MediaForm = () => (
  <div className="ep-section-panel">
    <h5 className="fw-bold text-center mb-4">Media</h5>
    <div className="upload-zone d-flex flex-column align-items-center justify-content-center p-5 rounded-4">
      <FiUploadCloud size={48} className="ep-upload-cloud mb-3" />
      <p className="mb-1 text-center">
        Drop your image here or <span className="ep-link-browse fw-semibold">Browse</span>
      </p>
      <p className="text-muted small mb-0">Support: JPG, JPEG, PNG</p>
    </div>
    <div className="image-preview-grid mt-4 d-flex gap-3 flex-wrap">
      <div className="preview-item">
        <img src="https://images.unsplash.com/photo-1542291026-7eec264c27ff" alt="product" />
        <button type="button" className="remove-img" aria-label="Remove">
          <FiX size={14} />
        </button>
      </div>
      <div className="preview-item empty">
        <FiPlus size={20} className="text-muted" />
      </div>
    </div>
  </div>
);

const SocialForm = () => (
  <div className="ep-section-panel">
    <h5 className="fw-bold text-center mb-4">Social</h5>
    <form className="row g-3">
      {['Facebook', 'Instagram', 'LinkedIn', 'Dribble', 'Behance', 'UI8'].map((platform) => (
        <div className="col-md-6" key={platform}>
          <label className="form-label small fw-semibold text-secondary">{platform} Account</label>
          <input
            type="text"
            className="form-control custom-input ep-social-input"
            placeholder="@warner"
            autoComplete="off"
          />
        </div>
      ))}
    </form>
  </div>
);

const PricingForm = () => (
  <div className="ep-section-panel">
    <h5 className="fw-bold text-center mb-4">Pricing</h5>
    <form className="row g-3">
      <div className="col-md-6">
        <label className="form-label small fw-semibold text-secondary">Price</label>
        <input type="text" className="form-control custom-input text-secondary" defaultValue="$100" inputMode="decimal" />
      </div>
      <div className="col-md-6">
        <label className="form-label small fw-semibold text-secondary">Currency</label>
        <div className="position-relative">
          <select className="form-select custom-input text-secondary">
            <option>USD</option>
            <option>EUR</option>
            <option>VND</option>
          </select>
          <FiChevronDown size={18} className="ep-select-arrow" aria-hidden />
        </div>
      </div>
      <div className="col-md-6">
        <label className="form-label small fw-semibold text-secondary">SKU</label>
        <input type="text" className="form-control custom-input text-secondary" defaultValue="829672639" />
      </div>
      <div className="col-md-6">
        <label className="form-label small fw-semibold text-secondary">Tags</label>
        <input type="text" className="form-control custom-input text-secondary" defaultValue="In stock" />
      </div>
    </form>
  </div>
);

export default EditProduct;
