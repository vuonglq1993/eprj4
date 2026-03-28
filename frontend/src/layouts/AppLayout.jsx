import Sidebar from '../components/layout/Sidebar.jsx'
import Topbar from '../components/layout/Topbar.jsx'

function AppLayout({ children }) {
  return (
    <div className="app-layout">
      <Sidebar />

      <main className="app-layout__content">
        <Topbar />
        {children}
      </main>
    </div>
  )
}

export default AppLayout

