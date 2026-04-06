import React from 'react';

/**
 * 课程无缩略图时的静态占位：深蓝渐变底 + 三个并列圆角方块（不重叠、无模糊玻璃）。
 * 仅负责展示，不包含数据逻辑。
 */
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
