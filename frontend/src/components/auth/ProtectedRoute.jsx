import { Navigate, useLocation } from 'react-router-dom';
import { useAuth } from '../../contexts/AuthContext';
import { hasRole } from '../../utils/roleUtils';

function ProtectedRoute({ children, allowedRoles }) {
  const { isAuthenticated } = useAuth();
  const location = useLocation();

  if (!isAuthenticated) {
    return <Navigate to="/login" state={{ from: location }} replace />;
  }

  if (allowedRoles && allowedRoles.length > 0) {
    const raw = localStorage.getItem('auth_user');
    if (!raw) return <Navigate to="/login" state={{ from: location }} replace />;
    const user = JSON.parse(raw);
    if (!allowedRoles.includes(user?.role)) {
      return <Navigate to="/" state={{ from: location }} replace />;
    }
  }

  return children;
}

export default ProtectedRoute;
