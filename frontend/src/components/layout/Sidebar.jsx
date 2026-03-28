import { useState } from 'react'
import { useNavigate, useLocation, Link } from 'react-router-dom'
import {
  MdHome,
  MdPages,
  MdApps,
  MdShoppingCart,
  MdLockOutline,
  MdExpandMore,
  MdExpandLess,
  MdLogout,
} from 'react-icons/md'
import { useAuth } from '../../contexts/AuthContext'

const menuConfig = [
  {
    id: 'home',
    label: 'Home',
    icon: MdHome,
    children: [
      { id: 'dashboard', label: 'Dashboard', path: '/' },
      { id: 'analytics', label: 'Analytics', path: '/analytics' },
    ],
  },
  {
    id: 'pages',
    label: 'Pages',
    icon: MdPages,
    children: [
      {
        id: 'profile',
        label: 'Profile',
        children: [
          { id: 'profile-overview', label: 'Profile overview', path: '/profile-overview' },
          { id: 'teams', label: 'Teams', path: '/teams' },
          { id: 'all-projects', label: 'All Projects',path: '/allprojects'},
        ],
      },
      {
        id: 'user',
        label: 'User',
        children: [
          { id: 'report', label: 'Report', path: '/report' },
          { id: 'new-user', label: 'New User', path: '/new-user' },
        ],
      },
      {
        id: 'account',
        label: 'Account',
        children: [
          { id: 'setting', label: 'Setting', path: '/setting' },
          { id: 'billing', label: 'Billing', path: '/billing' },
          { id: 'invoice', label: 'Invoice', path: '/invoice' },
          { id: 'security', label: 'Security', path: '/security' },
        ],
      },
      {
        id: 'projects',
        label: 'Projects',
        children: [
          { id: 'general', label: 'General', path: '/general' },
          { id: 'timeline', label: 'Timeline', path: '/timeline' },
          { id: 'new-project', label: 'New Project', path: '/new-project' },
        ],
      },
      {
        label: 'Pricing Page',
        path: '/pricing-page',
        id: 'pricing-page',
      },
      {
        label: 'Charts',
        path: '/charts',
        id: 'charts', 
      },
      {
        label: 'Notification',
        path: '/notification',
        id:'/notification'
      },
      {
        label: 'Chat',
        path: '/chat',
        id:'/chat'
      }

    ],
  },
  {
    id: 'applications',
    label: 'Applications',
    icon: MdApps,
    children: [
      { id: 'kanban', label: 'Kanban', path: '/kanban' },
      { id: 'wizard', label: 'Wizard', path: '/wizard' },
      { id: 'data-tables', label: 'Data tables', path: '/datatables' },
      { id: 'calendar', label: 'Calendar',path: '/calendar' },
    ],
  },
  {
    id: 'ecommerce',
    label: 'E-commerce',
    icon: MdShoppingCart,
    children: [
      { id: 'overview', label: 'Overview' },
      {
        id: 'products',
        label: 'Products',
        children: [
          { id: 'new-product', label: 'New Product',path: '/new-product' },
          { id: 'edit-product', label: 'Edit Product',path: '/edit-product' },
          { id: 'product-list', label: 'Product List', path: '/product-list' },
        ],
      },
      { id: 'orders', label: 'Orders' },
    ],
  },
  {
    id: 'authentication',
    label: 'Authentication',
    icon: MdLockOutline,
  },
]

function Sidebar({ onNavigate }) {
  const navigate = useNavigate()
  const location = useLocation()
  const { logout } = useAuth()
  const [expandedIds, setExpandedIds] = useState(new Set(['home', 'pages', 'profile']))

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
          <Link to={item.path} className={baseClass} onClick={() => onNavigate?.()}>
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
