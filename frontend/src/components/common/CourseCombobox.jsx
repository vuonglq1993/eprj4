import React, { useState, useEffect, useRef } from 'react';
import { FiSearch, FiChevronDown, FiX, FiChevronUp } from 'react-icons/fi';
import { getCourses } from '../../services/courseService';

function CourseCombobox({ value, onChange, disabled }) {
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState('');
  const [options, setOptions] = useState([]);
  const [loading, setLoading] = useState(false);
  const [selectedLabel, setSelectedLabel] = useState('');
  const wrapperRef = useRef(null);

  useEffect(() => {
    if (!value) { setSelectedLabel(''); return; }
    const match = options.find((o) => o.id === value);
    if (match) { setSelectedLabel(match.title); return; }
    // fetch label for current value in case it's not in options yet
    (async () => {
      try {
        const res = await getCourses({ kw: '', page: 0, size: 50 });
        const list = res.data?.content ?? res.data ?? [];
        const found = list.find((c) => c.id === value);
        if (found) { setSelectedLabel(found.title); }
      } catch {}
    })();
  }, [value, options]);

  useEffect(() => {
    if (!open) return;
    let cancelled = false;
    (async () => {
      setLoading(true);
      try {
        const res = await getCourses({ kw: query, page: 0, size: 10 });
        if (!cancelled) setOptions(res.data?.content ?? res.data ?? []);
      } catch {
        if (!cancelled) setOptions([]);
      } finally {
        if (!cancelled) setLoading(false);
      }
    })();
    return () => { cancelled = true; };
  }, [query, open]);

  // close on outside click
  useEffect(() => {
    function handler(e) {
      if (wrapperRef.current && !wrapperRef.current.contains(e.target)) setOpen(false);
    }
    if (open) document.addEventListener('mousedown', handler);
    return () => document.removeEventListener('mousedown', handler);
  }, [open]);

  const handleSelect = (course) => {
    onChange(course.id);
    setQuery('');
    setOpen(false);
  };

  const handleClear = (e) => {
    e.stopPropagation();
    onChange('');
    setSelectedLabel('');
    setQuery('');
    setOptions([]);
  };

  const displayed = query ? options.filter((o) =>
    o.title.toLowerCase().includes(query.toLowerCase())
  ) : options;

  return (
    <div className="course-combobox" ref={wrapperRef}>
      <div
        className={`course-combobox__control ${disabled ? 'disabled' : ''}`}
        onClick={() => !disabled && setOpen((v) => !v)}
        role="combobox"
        aria-expanded={open}
        aria-haspopup="listbox"
        aria-disabled={disabled}
      >
        <span className={`course-combobox__selected-text ${!selectedLabel ? 'placeholder' : ''}`}>
          {selectedLabel || 'Select course…'}
        </span>
        <div className="course-combobox__actions">
          {value && !disabled && (
            <span role="button" className="course-combobox__clear" onClick={handleClear} aria-label="Clear">
              <FiX size={14} />
            </span>
          )}
          <span className="course-combobox__arrow">
            {open ? <FiChevronUp size={16} /> : <FiChevronDown size={16} />}
          </span>
        </div>
      </div>

      {open && (
        <div className="course-combobox__dropdown" role="listbox">
          <div className="course-combobox__search-wrapper">
            <FiSearch size={15} className="course-combobox__search-icon" />
            <input
              className="course-combobox__search"
              type="text"
              placeholder="Search courses…"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              autoFocus
              onClick={(e) => e.stopPropagation()}
            />
          </div>

          <div className="course-combobox__options">
            {loading ? (
              <div className="course-combobox__message">Đang tải…</div>
            ) : displayed.length === 0 ? (
              <div className="course-combobox__message">Không tìm thấy khóa học.</div>
            ) : (
              displayed.map((course) => (
                <div
                  key={course.id}
                  className={`course-combobox__option ${course.id === value ? 'selected' : ''}`}
                  role="option"
                  aria-selected={course.id === value}
                  onClick={() => handleSelect(course)}
                >
                  <span className="course-combobox__option-title">{course.title}</span>
                  <span className="course-combobox__option-meta">{course.languageName}</span>
                </div>
              ))
            )}
          </div>
        </div>
      )}
    </div>
  );
}

export default CourseCombobox;
