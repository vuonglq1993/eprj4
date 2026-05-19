import React from 'react';


export function CourseThumbnailPlaceholder() {
  return (
    <div className="cl-card-thumb-placeholder" aria-hidden="true">
      <div className="cl-card-thumb-placeholder__row">
        <span className="cl-card-thumb-placeholder__sq" />
        <span className="cl-card-thumb-placeholder__sq cl-card-thumb-placeholder__sq--mid" />
        <span className="cl-card-thumb-placeholder__sq" />
      </div>
    </div>
  );
}
