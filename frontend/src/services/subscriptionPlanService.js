import api from './api';

/**
 * Backend trả về array trực tiếp (ví dụ: store.subscriptionPlans)
 * hoặc object dạng { content: [...] }, { data: [...] } tùy API.
 * Hàm này trích array từ mọi shape.
 */
function extractArray(data) {
  if (Array.isArray(data)) return data;
  if (data && typeof data === 'object') {
    if (Array.isArray(data.content)) return data.content;
    if (Array.isArray(data.data)) return data.data;
    if (Array.isArray(data.plans)) return data.plans;
    if (Array.isArray(data.items)) return data.items;
  }
  return [];
}

/**
 * Chuẩn hoá từng plan từ snake_case backend → camelCase UI.
 * Backend trả: id, name, description, price, currency, durationDays, features, isActive.
 * Field features có thể là array [] hoặc chuỗi JSON "[\"...\"]".
 */
export function normalizeSubscriptionPlan(raw) {
  if (raw == null || typeof raw !== 'object') return null;

  let featuresArr = [];
  const rawFeatures = raw.features;
  if (Array.isArray(rawFeatures)) {
    featuresArr = rawFeatures;
  } else if (typeof rawFeatures === 'string' && rawFeatures.trim()) {
    try {
      const parsed = JSON.parse(rawFeatures);
      featuresArr = Array.isArray(parsed) ? parsed : [];
    } catch {
      featuresArr = [];
    }
  }

  return {
    id: raw.id,
    name: raw.name ?? '',
    description: raw.description ?? '',
    price: raw.price != null ? Number(raw.price) : 0,
    currency: raw.currency ?? 'VND',
    durationDays: raw.durationDays ?? raw.duration_days ?? 30,
    isActive: raw.isActive ?? raw.is_active ?? true,
    features: featuresArr,
    createdAt: raw.createdAt ?? null,
    updatedAt: raw.updatedAt ?? null,
  };
}

export function normalizePlansListResponse(res) {
  const data = res?.data ?? res;
  const arr = extractArray(data);
  return arr.map(normalizeSubscriptionPlan).filter(Boolean);
}

/** Sort: giá tăng dần, rồi theo tên A-Z */
export function sortPlansForDisplay(list) {
  return [...list].sort((a, b) => {
    const pa = Number(a?.price) || 0;
    const pb = Number(b?.price) || 0;
    if (pa !== pb) return pa - pb;
    return String(a?.name || '').localeCompare(String(b?.name || ''), undefined, { sensitivity: 'base' });
  });
}

export const getSubscriptionPlans = () => api.get('/subscription-plans');
export const createSubscriptionPlan = (data) => api.post('/subscription-plans', data);
export const updateSubscriptionPlan = (id, data) => api.put(`/subscription-plans/${id}`, data);
export const toggleSubscriptionPlan = (id) => api.patch(`/subscription-plans/${id}/toggle`);
export const deleteSubscriptionPlan = (id) => api.delete(`/subscription-plans/${id}`);
