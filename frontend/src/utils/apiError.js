/**
 * Lấy chuỗi lỗi từ response Axios (GlobalExceptionHandler Err hoặc Spring Security JSON).
 */
export function getApiErrorMessage(err) {
  const d = err.response?.data;
  if (d == null) return err.message || '';
  if (typeof d === 'string') return d;
  if (typeof d.message === 'string' && d.message.trim()) {
    if (d.errors && typeof d.errors === 'object' && !Array.isArray(d.errors)) {
      const parts = Object.entries(d.errors).map(([k, v]) => `${k}: ${v}`);
      if (parts.length) return `${d.message} — ${parts.join('; ')}`;
    }
    return d.message;
  }
  if (typeof d.error === 'string' && d.error.trim()) return d.error;
  return '';
}
