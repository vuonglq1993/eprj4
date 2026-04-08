import React, { useEffect, useState } from 'react';
import '../../styles/dataTablesPages.css';
import { getSubscriptionStatus } from '../../services/learningDataService';
import {
  MdOutlineSubscriptions,
  MdOutlineVerified,
  MdOutlineWorkspacePremium,
  MdEvent,
  MdAutorenew,
  MdHourglassEmpty,
} from 'react-icons/md';

function planBadgeClass(plan) {
  const p = (plan || '').toUpperCase();
  if (p === 'FREE') return 'sub-menu__badge sub-menu__badge--plan-free';
  return 'sub-menu__badge sub-menu__badge--plan-paid';
}

function statusBadgeClass(status) {
  const s = (status || '').toUpperCase();
  if (s === 'ACTIVE') return 'sub-menu__badge sub-menu__badge--status-active';
  if (s === 'EXPIRED' || s === 'CANCELLED') return 'sub-menu__badge sub-menu__badge--status-warn';
  return 'sub-menu__badge sub-menu__badge--status-muted';
}

export default function SubscriptionsPage() {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    let cancelled = false;
    (async () => {
      setLoading(true);
      setError('');
      try {
        const res = await getSubscriptionStatus();
        if (!cancelled) setData(res.data || null);
      } catch (err) {
        const d = err.response?.data;
        const msg =
          (typeof d === 'string' && d) ||
          d?.message ||
          d?.code ||
          'Không tải được dữ liệu (API /subscriptions/status).';
        if (!cancelled) setError(msg);
      } finally {
        if (!cancelled) setLoading(false);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, []);

  const fmt = (v) => (v == null || v === '' ? '—' : String(v));

  return (
    <div className="db-page py-4 px-3">
      <div className="db-inner mx-auto">
        <h2 className="fw-bold mb-4" style={{ fontSize: '1.5rem', color: '#1e293b' }}>subscriptions</h2>

        {error && <div className="alert alert-danger py-2">{error}</div>}
        {loading ? (
          <div className="text-center py-5 text-muted">Đang tải…</div>
        ) : data && (
          <div className="db-card shadow-sm p-3 p-md-4">
            <nav className="sub-menu" aria-label="Thông tin subscription">
              <div className="sub-menu__grid">
                <div className="sub-menu__item">
                  <div className="sub-menu__item-head">
                    <MdOutlineSubscriptions size={18} aria-hidden />
                    Gói (plan)
                  </div>
                  <span className={planBadgeClass(data.plan)}>{fmt(data.plan)}</span>
                </div>

                <div className="sub-menu__item">
                  <div className="sub-menu__item-head">
                    <MdOutlineVerified size={18} aria-hidden />
                    Trạng thái (status)
                  </div>
                  <span className={statusBadgeClass(data.status)}>{fmt(data.status)}</span>
                </div>

                <div className="sub-menu__item">
                  <div className="sub-menu__item-head">
                    <MdOutlineWorkspacePremium size={18} aria-hidden />
                    Premium
                  </div>
                  <span className={data.isPremium ? 'sub-menu__badge sub-menu__badge--premium' : 'sub-menu__item-value'}>
                    {data.isPremium ? 'Đang bật' : 'Chưa kích hoạt'}
                  </span>
                </div>

                <div className="sub-menu__item">
                  <div className="sub-menu__item-head">
                    <MdEvent size={18} aria-hidden />
                    Ngày bắt đầu
                  </div>
                  <div className="sub-menu__item-value">{fmt(data.startDate)}</div>
                </div>

                <div className="sub-menu__item">
                  <div className="sub-menu__item-head">
                    <MdEvent size={18} aria-hidden />
                    Ngày kết thúc
                  </div>
                  <div className="sub-menu__item-value">{fmt(data.endDate)}</div>
                </div>

                <div className="sub-menu__item">
                  <div className="sub-menu__item-head">
                    <MdAutorenew size={18} aria-hidden />
                    Tự động gia hạn
                  </div>
                  <div className="sub-menu__item-value">{data.autoRenew ? 'Bật' : 'Tắt'}</div>
                </div>
              </div>

              <div className="sub-menu__item sub-menu__item--wide">
                <div className="sub-menu__item-head">
                  <MdHourglassEmpty size={18} aria-hidden />
                  Thời hạn còn lại
                </div>
                <div className="sub-menu__item-value">
                  {data.daysRemaining != null
                    ? `${data.daysRemaining} ngày`
                    : '—'}
                </div>
              </div>
            </nav>
          </div>
        )}
      </div>
    </div>
  );
}
