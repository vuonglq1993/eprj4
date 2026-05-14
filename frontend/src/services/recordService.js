import api from './api';

export const uploadRecord = async (file, title, exerciseId) => {
  const formData = new FormData();
  formData.append('file', file);
  formData.append('title', title);
  formData.append('exerciseId', exerciseId);
  const response = await api.post('/records/upload', formData, {
    headers: { 'Content-Type': 'multipart/form-data' },
  });
  return response.data;
};

export const getRecordsByExercise = (exerciseId) =>
  api.get(`/records/exercise/${exerciseId}`);
