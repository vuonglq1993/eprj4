import { useLocation } from 'react-router-dom'
import { IoSearch } from 'react-icons/io5'
import { MdMenu } from 'react-icons/md'

const PAGE_TITLES = {
  '/':                          'Dashboard',
  '/languages':                 'Ngôn ngữ',
  '/learning-paths':            'Lộ trình học',
  '/topics':                    'Chủ đề',
  '/courses':                   'Khoá học',
  '/lessons':                   'Bài học',
  '/exercises':                 'Bài tập',
  '/admin/users':               'Người dùng',
  '/admin/subscription-plans':  'Gói đăng ký',
  '/data/payment-transactions': 'Giao dịch',
  '/game/leaderboard':          'Bảng xếp hạng',
  '/admin/notifications':       'Thông báo',
  '/reports/weekly':            'Báo cáo',
  '/setting':                   'Cài đặt',
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
          placeholder="Tìm kiếm..."
        />
        <IoSearch className="topbar__search-icon" aria-hidden />
      </div>
    </header>
  )
}

export default Topbar
