import { useNavigate, useLocation, Link } from 'react-router-dom'
import {
  MdDashboard,
  MdLanguage,
  MdRoute,
  MdCategory,
  MdSchool,
  MdMenuBook,
  MdAssignment,
  MdPeople,
  MdCardMembership,
  MdPayment,
  MdLeaderboard,
  MdNotifications,
  MdBarChart,
  MdSettings,
  MdLogout,
  MdMic,
} from 'react-icons/md'
import { useAuth } from '../../contexts/AuthContext'

const menuConfig = [
  { id: 'dashboard',      label: 'Dashboard',      icon: MdDashboard,      path: '/' },

  { id: 'div-content',    label: 'Nội dung',        type: 'divider' },
  { id: 'languages',      label: 'Ngôn ngữ',        icon: MdLanguage,       path: '/languages' },
  { id: 'learning-paths', label: 'Lộ trình học',    icon: MdRoute,          path: '/learning-paths' },
  { id: 'topics',         label: 'Chủ đề',          icon: MdCategory,       path: '/topics' },
  { id: 'courses',        label: 'Khoá học',        icon: MdSchool,         path: '/courses' },
  { id: 'lessons',        label: 'Bài học',         icon: MdMenuBook,       path: '/lessons' },
  { id: 'exercises',      label: 'Bài tập',         icon: MdAssignment,     path: '/exercises' },
  { id: 'recordings',     label: 'Ghi âm',           icon: MdMic,           path: '/recordings' },

  { id: 'div-admin',      label: 'Quản lý',         type: 'divider' },
  { id: 'users',          label: 'Người dùng',      icon: MdPeople,         path: '/admin/users' },
  { id: 'subscriptions',  label: 'Gói đăng ký',     icon: MdCardMembership, path: '/admin/subscription-plans' },
  { id: 'transactions',   label: 'Giao dịch',       icon: MdPayment,        path: '/data/payment-transactions' },

  { id: 'div-community',  label: 'Cộng đồng',       type: 'divider' },
  { id: 'leaderboard',    label: 'Bảng xếp hạng',   icon: MdLeaderboard,    path: '/game/leaderboard' },

  { id: 'div-system',     label: 'Hệ thống',        type: 'divider' },
  { id: 'notifications',  label: 'Thông báo',       icon: MdNotifications,  path: '/admin/notifications' },
  { id: 'reports',        label: 'Báo cáo',         icon: MdBarChart,       path: '/reports/weekly' },
  { id: 'settings',       label: 'Cài đặt',         icon: MdSettings,       path: '/setting' },
]

function Sidebar({ onNavigate }) {
  const navigate = useNavigate()
  const location = useLocation()
  const { logout } = useAuth()

  const handleLogout = () => {
    onNavigate?.()
    logout()
    navigate('/login', { replace: true })
  }

  return (
    <aside className="sidebar">
      <div className="sidebar__logo">
        <div className="sidebar__logo-mark">M</div>
        <span className="sidebar__logo-text">Admin</span>
      </div>

      <nav className="sidebar__nav" aria-label="Main navigation">
        {menuConfig.map((item) => {
          if (item.type === 'divider') {
            return (
              <div key={item.id} className="sidebar__section-label">
                {item.label}
              </div>
            )
          }

          const Icon = item.icon
          const isActive = location.pathname === item.path

          return (
            <Link
              key={item.id}
              to={item.path}
              className={`sidebar__nav-item ${isActive ? 'sidebar__nav-item--active' : ''}`}
              onClick={() => { window.scrollTo(0, 0); onNavigate?.() }}
            >
              <Icon className="sidebar__nav-icon" aria-hidden />
              <span className="sidebar__nav-label">{item.label}</span>
            </Link>
          )
        })}
      </nav>

      <div className="sidebar__footer">
        <button
          type="button"
          className="sidebar__nav-item sidebar__nav-item--logout"
          onClick={handleLogout}
        >
          <MdLogout className="sidebar__nav-icon" />
          <span className="sidebar__nav-label">Đăng xuất</span>
        </button>
      </div>
    </aside>
  )
}

export default Sidebar
