import React, { useEffect, useRef, useState } from 'react';
import { FiUploadCloud, FiX, FiPlus } from 'react-icons/fi';

const STEPS = [
  { id: 1, label: 'Product Info' },
  { id: 2, label: 'Media' },
  { id: 3, label: 'Social' },
  { id: 4, label: 'Pricing' },
];

const NewProduct = () => {
  const [step, setStep] = useState(1);
  const fileInputRef = useRef(null);
  const pageRef = useRef(null);

  useEffect(() => {
    pageRef.current?.scrollIntoView({ block: 'start', behavior: 'smooth' });
  }, [step]);

  const [form, setForm] = useState({
    name: 'Off -White',
    weight: '42',
    size: 'Large',
    category: 'Clothing',
    description: 'Some initial bold text',
    facebook: '',
    instagram: '',
    linkedin: '',
    dribble: '',
    behance: '',
    ui8: '',
    price: '$100',
    currency: 'USD',
    sku: '829672639',
    tags: 'In stock',
  });

  const update = (field) => (e) => {
    setForm((prev) => ({ ...prev, [field]: e.target.value }));
  };

  const goNext = () => {
    if (step < 4) setStep((s) => s + 1);
    else window.alert('Product saved (demo).');
  };

  const isStepDone = (id) => id <= step;

  return (
    <div className="new-product-page py-4 px-3" ref={pageRef}>
      <div className="new-product-inner mx-auto">
        <div className="text-center mb-4">
          <h2 className="fw-bold mb-1">New Product</h2>
          <p className="text-muted small mb-0">Create a new product for your store</p>
        </div>

        <div className="np-stepper d-flex align-items-center justify-content-center flex-wrap mb-4">
          {STEPS.map((s, index) => (
            <React.Fragment key={s.id}>
              <div
                className={`np-step d-flex flex-column align-items-center ${isStepDone(s.id) ? 'np-step--active' : 'np-step--todo'}`}
              >
                <div className="np-step-circle">{s.id}</div>
                <span className="np-step-label small fw-semibold mt-2 text-center">{s.label}</span>
              </div>
              {index < STEPS.length - 1 && (
                <div className={`np-step-connector ${step > s.id ? 'np-step-connector--done' : ''}`} aria-hidden />
              )}
            </React.Fragment>
          ))}
        </div>

        <div className="form-section shadow-sm np-wizard-card p-4 p-md-5">
          {step === 1 && (
            <div className="np-step-panel">
              <h5 className="fw-bold text-center mb-4">Product Information</h5>
              <div className="row g-3 mb-3">
                <div className="col-md-6">
                  <label className="form-label small fw-semibold">Name</label>
                  <input type="text" className="form-control custom-input" value={form.name} onChange={update('name')} />
                </div>
                <div className="col-md-6">
                  <label className="form-label small fw-semibold">Weight</label>
                  <input type="text" className="form-control custom-input" value={form.weight} onChange={update('weight')} />
                </div>
                <div className="col-md-6">
                  <label className="form-label small fw-semibold">Sizes</label>
                  <select className="form-select custom-input" value={form.size} onChange={update('size')}>
                    <option value="Small">Small</option>
                    <option value="Medium">Medium</option>
                    <option value="Large">Large</option>
                  </select>
                </div>
                <div className="col-md-6">
                  <label className="form-label small fw-semibold">Category</label>
                  <select className="form-select custom-input" value={form.category} onChange={update('category')}>
                    <option value="Clothing">Clothing</option>
                    <option value="Footwear">Footwear</option>
                    <option value="Accessories">Accessories</option>
                  </select>
                </div>
                <div className="col-12">
                  <label className="form-label small fw-semibold">Description</label>
                  <textarea
                    className="form-control custom-input"
                    rows={4}
                    value={form.description}
                    onChange={update('description')}
                  />
                </div>
              </div>
            </div>
          )}

          {step === 2 && (
            <div className="np-step-panel">
              <h5 className="fw-bold text-center mb-4">Media</h5>
              <button
                type="button"
                className="upload-zone w-100 border-0 bg-transparent p-0 text-start"
                onClick={() => fileInputRef.current?.click()}
              >
                <div className="upload-zone-inner d-flex flex-column align-items-center justify-content-center p-5 rounded-4">
                  <FiUploadCloud size={48} className="np-upload-cloud mb-3" />
                  <p className="mb-1 text-center">
                    Drop your image here or{' '}
                    <span className="np-link-browse fw-semibold">Browse</span>
                  </p>
                  <p className="text-muted small mb-0">Support: JPG, JPEG, PNG</p>
                </div>
              </button>
              <input ref={fileInputRef} type="file" accept="image/jpeg,image/jpg,image/png" className="d-none" multiple />

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
          )}

          {step === 3 && (
            <div className="np-step-panel">
              <h5 className="fw-bold text-center mb-4">Social</h5>
              <div className="row g-3">
                <div className="col-md-6">
                  <label className="form-label small fw-semibold">Facebook Account</label>
                  <input type="text" className="form-control custom-input" placeholder="@warner" value={form.facebook} onChange={update('facebook')} />
                </div>
                <div className="col-md-6">
                  <label className="form-label small fw-semibold">Instagram Account</label>
                  <input type="text" className="form-control custom-input" placeholder="@warner" value={form.instagram} onChange={update('instagram')} />
                </div>
                <div className="col-md-6">
                  <label className="form-label small fw-semibold">LinkedIn Account</label>
                  <input type="text" className="form-control custom-input" placeholder="@warner" value={form.linkedin} onChange={update('linkedin')} />
                </div>
                <div className="col-md-6">
                  <label className="form-label small fw-semibold">Dribble Account</label>
                  <input type="text" className="form-control custom-input" placeholder="@warner" value={form.dribble} onChange={update('dribble')} />
                </div>
                <div className="col-md-6">
                  <label className="form-label small fw-semibold">Behance Account</label>
                  <input type="text" className="form-control custom-input" placeholder="@warner" value={form.behance} onChange={update('behance')} />
                </div>
                <div className="col-md-6">
                  <label className="form-label small fw-semibold">UI8 Account</label>
                  <input type="text" className="form-control custom-input" placeholder="@warner" value={form.ui8} onChange={update('ui8')} />
                </div>
              </div>
            </div>
          )}

          {step === 4 && (
            <div className="np-step-panel">
              <h5 className="fw-bold text-center mb-4">Pricing</h5>
              <div className="row g-3">
                <div className="col-md-6">
                  <label className="form-label small fw-semibold">Price</label>
                  <input type="text" className="form-control custom-input" value={form.price} onChange={update('price')} />
                </div>
                <div className="col-md-6">
                  <label className="form-label small fw-semibold">Currency</label>
                  <select className="form-select custom-input" value={form.currency} onChange={update('currency')}>
                    <option value="USD">USD</option>
                    <option value="EUR">EUR</option>
                    <option value="VND">VND</option>
                  </select>
                </div>
                <div className="col-md-6">
                  <label className="form-label small fw-semibold">SKU</label>
                  <input type="text" className="form-control custom-input" value={form.sku} onChange={update('sku')} />
                </div>
                <div className="col-md-6">
                  <label className="form-label small fw-semibold">Tags</label>
                  <input type="text" className="form-control custom-input" value={form.tags} onChange={update('tags')} />
                </div>
              </div>
            </div>
          )}

          <div className="d-flex justify-content-end mt-4 pt-2">
            <button type="button" className="btn btn-primary-purple px-4 py-2" onClick={goNext}>
              Next
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default NewProduct;
