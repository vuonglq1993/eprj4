import { useCallback, useEffect, useState } from 'react'
import { useLocation } from 'react-router-dom'
import Sidebar from '../components/layout/Sidebar.jsx'
import Topbar from '../components/layout/Topbar.jsx'

function AppLayout({ children }) {
  const [navOpen, setNavOpen] = useState(false)
  const location = useLocation()

  const closeNav = useCallback(() => setNavOpen(false), [])

  useEffect(() => {
    window.scrollTo(0, 0)
    const main = document.querySelector('.app-layout__content')
    if (main) main.scrollTop = 0
  }, [location.pathname])

  useEffect(() => {
    if (!navOpen) return
    const prev = document.body.style.overflow
    document.body.style.overflow = 'hidden'
    const onKey = (e) => {
      if (e.key === 'Escape') setNavOpen(false)
    }
    window.addEventListener('keydown', onKey)
    return () => {
      document.body.style.overflow = prev
      window.removeEventListener('keydown', onKey)
    }
  }, [navOpen])

  return (
    <div className={`app-layout${navOpen ? ' app-layout--nav-open' : ''}`}>
      <button
        type="button"
        className="sidebar-backdrop"
        aria-label="Đóng menu"
        tabIndex={-1}
        onClick={closeNav}
      />
      <Sidebar onNavigate={closeNav} />
      <main className="app-layout__content">
        <Topbar onOpenNav={() => setNavOpen(true)} />
        {children}
      </main>
    </div>
  )
}

export default AppLayout

