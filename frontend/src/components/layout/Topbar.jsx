import { useLocation } from 'react-router-dom'
import { IoSearch } from 'react-icons/io5'
import { MdMenu } from 'react-icons/md'

const PAGE_TITLES = {
  '/': 'Dashboard',
  '/teams': 'Pages/Teams',
  '/profile-overview': 'Profile overview',
  '/report': 'Users / Reports',
  '/setting': 'Account / Setting',
  '/timeline': 'Projects / Timeline',
  '/pricing-page': 'Pricing Page',
  '/charts': 'Charts',
  '/notification': 'Notification',
  '/chat': 'Chat',
  '/new-user': 'Users / New User',
  '/billing': 'Account / Billing',
  '/new-project': 'Project / New Project',
  '/allprojects': 'Pages/All projects',
  '/invoice': 'Account / Invoice',
  '/kanban': 'Kanban',
  '/datatables': 'Data Tables',
  '/wizard': 'Wizard',
  '/calendar': 'Calendar',
  '/new-product': 'New Product',
  '/languages': 'Languages',
  '/courses': 'Courses',
  '/lessons': 'Lessons',
  '/exercises': 'Exercises',
  '/progress': 'My Progress',
  '/learning-paths': 'Learning Paths',
  '/topics': 'Topics',
  '/admin/subscription-plans': 'Subscription Plans',
  '/reviews/mistakes': 'Review Mistakes',
  '/reports/weekly': 'Weekly Report',
  '/game/profile': 'My Profile',
  '/game/leaderboard': 'Leaderboard',
  '/admin/users': 'User Management',
}


function Topbar({ onOpenNav }) {
  const { pathname } = useLocation()
  const title = PAGE_TITLES[pathname] ?? 'Dashboard'

  return (
    <header className="topbar">
      <div className="topbar__leading">
        <button
          type="button"
          className="topbar__menu-btn"
          aria-label="Mở menu"
          onClick={() => onOpenNav?.()}
        >
          <MdMenu size={22} aria-hidden />
        </button>
        <h1 className="topbar__title">{title}</h1>
      </div>

      <div className="topbar__search">
        <input
          type="text"
          className="topbar__search-input"
          placeholder="Search anything here..."
        />
        <IoSearch className="topbar__search-icon" aria-hidden />
      </div>
    </header>
  )
}

export default Topbar

