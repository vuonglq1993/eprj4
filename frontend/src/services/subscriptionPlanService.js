import api from './api';

/**
 * Chuẩn hoá từ API / DB (snake_case) sang một object dùng trong UI (camelCase).
 * Bảng subscription_plans: id, name, description, price, duration_days, is_active (+ có thể có currency, features).
 */
export function normalizeSubscriptionPlan(raw) {
  if (raw == null || typeof raw !== 'object') return raw;
  const features = raw.features;
  let featuresArr = [];
  if (Array.isArray(features)) featuresArr = features;
  else if (typeof features === 'string' && features.trim()) {
    try {
      const parsed = JSON.parse(features);
      featuresArr = Array.isArray(parsed) ? parsed : [];
    } catch {
      featuresArr = [];
    }
  }
  return {
    ...raw,
    name: raw.name ?? '',
    description: raw.description ?? '',
    price: raw.price != null ? Number(raw.price) : 0,
    durationDays: raw.durationDays ?? raw.duration_days ?? 30,
    isActive: raw.isActive ?? Boolean(raw.is_active ?? true),
    currency: raw.currency ?? 'VND',
    features: featuresArr,
  };
}

export function normalizePlansListResponse(data) {
  const arr = Array.isArray(data) ? data : data?.content ?? data?.data ?? [];
  if (!Array.isArray(arr)) return [];
  return arr.map(normalizeSubscriptionPlan);
}

export function sortPlansForDisplay(list) {
  return [...list].sort((a, b) => {
    const pa = Number(a?.price) || 0;
    const pb = Number(b?.price) || 0;
    if (pa !== pb) return pa - pb;
    return String(a?.name || '').localeCompare(String(b?.name || ''), undefined, { sensitivity: 'base' });
  });
}

export const getSubscriptionPlans = () => api.get('/subscription-plans');

export const createSubscriptionPlan = (data) =>
  api.post('/subscription-plans', data);

export const updateSubscriptionPlan = (id, data) =>
  api.put(`/subscription-plans/${id}`, data);

export const toggleSubscriptionPlan = (id) =>
  api.patch(`/subscription-plans/${id}/toggle`);
