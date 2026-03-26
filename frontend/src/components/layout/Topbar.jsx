import { useLocation } from 'react-router-dom'
import { IoSearch } from 'react-icons/io5'

const PAGE_TITLES = {
  '/': 'Dashboard',
  '/analytics': 'Analytics',
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
  '/security': 'Account / Security',
  '/kanban': 'Kanban',
  '/datatables': 'Data Tables',


}

function Topbar() {
  const { pathname } = useLocation()
  const title = PAGE_TITLES[pathname] ?? 'Dashboard'

  return (
    <header className="topbar">
      <h1 className="topbar__title">{title}</h1>

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

