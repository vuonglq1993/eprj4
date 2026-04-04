import React, { useEffect, useState } from 'react';
import '../../styles/dataTablesPages.css';
import { getPaymentHistory } from '../../services/learningDataService';

export default function PaymentTransactionsPage() {
  const [rows, setRows] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    let cancelled = false;
    (async () => {
      setLoading(true);
      setError('');
      try {
        const res = await getPaymentHistory();
        if (!cancelled) setRows(res.data || []);
      } catch {
        if (!cancelled) setError('Không tải được payment_transactions (API /payments/history).');
      } finally {
        if (!cancelled) setLoading(false);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, []);

  const fmt = (v) => (v == null || v === '' ? '—' : String(v));

  const shortId = (uuid) => {
    if (uuid == null || uuid === '') return '—';
    const s = String(uuid);
    if (s.length <= 12) return s;
    return `${s.slice(0, 8)}…`;
  };

  return (
    <div className="db-page py-4 px-3">
      <div className="db-inner mx-auto">
        <h2 className="fw-bold mb-4" style={{ fontSize: '1.5rem', color: '#1e293b' }}>payment_transactions</h2>
        {error && <div className="alert alert-danger py-2">{error}</div>}
        {loading ? (
          <div className="text-center py-5 text-muted">Đang tải…</div>
        ) : (
          <div className="db-card shadow-sm">
            <div className="table-responsive">
              <table className="table db-table mb-0">
                <thead>
                  <tr>
                    <th>id</th>
                    <th>gateway</th>
                    <th>amount</th>
                    <th>currency</th>
                    <th>plan</th>
                    <th>status</th>
                    <th>gateway_ref</th>
                    <th>created_at</th>
                    <th>paid_at</th>
                  </tr>
                </thead>
                <tbody>
                  {rows.map((r) => (
                    <tr key={r.id}>
                      <td title={fmt(r.id)}><code className="small">{shortId(r.id)}</code></td>
                      <td>{fmt(r.gateway)}</td>
                      <td className="text-end">{r.amount != null ? String(r.amount) : '—'}</td>
                      <td>{fmt(r.currency)}</td>
                      <td>{fmt(r.plan)}</td>
                      <td>{fmt(r.status)}</td>
                      <td><span className="small text-break">{fmt(r.gatewayRef)}</span></td>
                      <td className="text-nowrap small">{fmt(r.createdAt)}</td>
                      <td className="text-nowrap small">{fmt(r.paidAt)}</td>
                    </tr>
                  ))}
                  {rows.length === 0 && (
                    <tr>
                      <td colSpan={9} className="text-center text-muted py-4">Chưa có giao dịch.</td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
