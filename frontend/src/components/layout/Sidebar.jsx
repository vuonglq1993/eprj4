import { useState } from 'react'
import { useNavigate, useLocation, Link } from 'react-router-dom'
import {
  MdHome,
  MdPages,
  MdExpandMore,
  MdExpandLess,
  MdLogout,
  MdLanguage,
  MdSchool,
  MdStorage,
  MdRoute,
  MdCategory,
  MdConfirmationNumber,
  MdAssessment,
  MdEmojiEvents,
} from 'react-icons/md'
import { useAuth } from '../../contexts/AuthContext'

const menuConfig = [
  {
    id: 'home',
    label: 'Home',
    icon: MdHome,
    children: [
      { id: 'dashboard', label: 'Dashboard', path: '/' },
    ],
  },
  {
    id: 'languages',
    label: 'Languages',
    icon: MdLanguage,
    children: [
      { id: 'language-list', label: 'Languages', path: '/languages' },
    ],
  },
  {
    id: 'courses',
    label: 'Courses',
    icon: MdSchool,
    children: [
      { id: 'course-list', label: 'Courses', path: '/courses' },
      { id: 'lesson-list', label: 'Lessons', path: '/lessons' },
      { id: 'exercise-list', label: 'Exercises', path: '/exercises' },
    ],
  },
  {
    id: 'db-tables',
    label: 'Data Tables',
    icon: MdStorage,
    children: [
      { id: 'tbl-payment-transactions', label: 'payment_transactions', path: '/data/payment-transactions' },
    ],
  },
  {
    id: 'learning-paths',
    label: 'Learning Paths',
    icon: MdRoute,
    children: [
      { id: 'learning-paths-list', label: 'All Paths', path: '/learning-paths' },
    ],
  },
  {
    id: 'topics',
    label: 'Topics',
    icon: MdCategory,
    children: [
      { id: 'topics-list', label: 'All Topics', path: '/topics' },
    ],
  },
  {
    id: 'admin-plans',
    label: 'Subscription Plans',
    icon: MdConfirmationNumber,
    children: [
      { id: 'admin-plans-list', label: 'Manage Plans', path: '/admin/subscription-plans' },
    ],
  },
  {
    id: 'admin-users',
    label: 'User Management',
    icon: MdAssessment,
    children: [
      { id: 'admin-users-list', label: 'User Management', path: '/admin/users' },
    ],
  },
  {
    id: 'reports',
    label: 'Reports',
    icon: MdAssessment,
    children: [
      { id: 'weekly-report', label: 'Weekly Report', path: '/reports/weekly' },
      { id: 'review-mistakes', label: 'Review Mistakes', path: '/reviews/mistakes' },
    ],
  },
  {
    id: 'gamification',
    label: 'Achievements',
    icon: MdEmojiEvents,
    children: [
      { id: 'game-profile', label: 'My Profile', path: '/game/profile' },
      { id: 'leaderboard', label: 'Leaderboard', path: '/game/leaderboard' },
    ],
  },
  {
    id: 'pages',
    label: 'Pages',
    icon: MdPages,
    children: [
      { id: 'setting', label: 'Setting', path: '/setting' },
    ],
  },
]

function Sidebar({ onNavigate }) {
  const navigate = useNavigate()
  const location = useLocation()
  const { logout } = useAuth()
  const [expandedIds, setExpandedIds] = useState(new Set(['home', 'languages', 'courses', 'db-tables', 'pages', 'learning-paths', 'topics', 'admin-plans', 'gamification', 'reports']))

  const handleLogout = () => {
    onNavigate?.()
    logout()
    navigate('/login', { replace: true })
  }

  const toggle = (id) => {
    setExpandedIds((prev) => {
      const next = new Set(prev)
      if (next.has(id)) next.delete(id)
      else next.add(id)
      return next
    })
  }

  const hasChildren = (item) => item.children && item.children.length > 0
  const isExpanded = (id) => expandedIds.has(id)

  const renderItem = (item, depth = 0) => {
    const Icon = item.icon
    const isParent = hasChildren(item)
    const expanded = isParent && isExpanded(item.id)
    const hasPath = !!item.path
    const isActive = hasPath && location.pathname === item.path

    const depthClass = depth === 1 ? 'sidebar__nav-item--depth-1' : depth === 2 ? 'sidebar__nav-item--depth-2' : depth >= 3 ? 'sidebar__nav-item--depth-3' : ''
    const baseClass = `sidebar__nav-item ${depth > 0 ? 'sidebar__nav-item--child' : ''} ${depthClass} ${isActive ? 'sidebar__nav-item--active' : ''}`

    const content = (
      <>
        {Icon && <Icon className="sidebar__nav-icon" aria-hidden />}
        <span className="sidebar__nav-label">{item.label}</span>
        {isParent && (
          <span className="sidebar__nav-chevron" aria-hidden>
            {expanded ? <MdExpandLess /> : <MdExpandMore />}
          </span>
        )}
      </>
    )

    return (
      <div key={item.id} className="sidebar__group">
        {hasPath ? (
          <Link to={item.path} className={baseClass} onClick={() => { window.scrollTo(0, 0); onNavigate?.() }}>
            {content}
          </Link>
        ) : (
          <button
            type="button"
            className={baseClass}
            onClick={() => isParent && toggle(item.id)}
            data-depth={depth}
            aria-expanded={isParent ? expanded : undefined}
            aria-haspopup={isParent ? 'menu' : undefined}
          >
            {content}
          </button>
        )}

        {isParent && expanded && (
          <div className="sidebar__children">
            {item.children.map((child) => renderItem(child, depth + 1))}
          </div>
        )}
      </div>
    )
  }

  return (
    <aside className="sidebar">
      <div className="sidebar__logo">
        <div className="sidebar__logo-mark">M</div>
        <span className="sidebar__logo-text">Dashboard</span>
      </div>

      <nav className="sidebar__nav" aria-label="Main navigation">
        {menuConfig.map((item) => renderItem(item))}
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
