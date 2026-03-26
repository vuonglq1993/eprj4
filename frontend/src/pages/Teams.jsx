import { useState } from 'react'
import { MdEmail, MdAdd } from 'react-icons/md'
import '../styles/teams.css'

const PERMISSION_OPTIONS = ['Read-only', 'Admin', 'Editor', 'Viewer']

const members = [
  {
    id: 1,
    name: 'Oliva Rhye',
    email: 'Oliva@gmail.com',
    role: 'Admin',
    initials: 'OR',
  },
  {
    id: 2,
    name: 'Phoenix Baker',
    email: 'Phoenix@gmail.com',
    role: 'Admin',
    initials: 'PB',
  },
  {
    id: 3,
    name: 'Lana Steiner',
    email: 'Lana@gmail.com',
    role: 'Admin',
    initials: 'LS',
  },
  {
    id: 4,
    name: 'Demi Wilkinson',
    email: 'Demi@gmail.com',
    role: 'Admin',
    initials: 'DW',
  },
  {
    id: 5,
    name: 'Candice Wu',
    email: 'Candice@gmail.com',
    role: 'Admin',
    initials: 'CW',
  },
]

function Teams() {
  const [inviteRows, setInviteRows] = useState([
    { id: 1, email: '', permission: 'Read-only' },
    { id: 2, email: '', permission: 'Read-only' },
    { id: 3, email: '', permission: 'Read-only' },
  ])

  const addInviteRow = () => {
    setInviteRows((prev) => [
      ...prev,
      { id: Math.max(0, ...prev.map((r) => r.id)) + 1, email: '', permission: 'Read-only' },
    ])
  }

  const updateInviteRow = (id, field, value) => {
    setInviteRows((prev) =>
      prev.map((r) => (r.id === id ? { ...r, [field]: value } : r))
    )
  }

  const handleSendInvites = () => {
    console.log('Send invites:', inviteRows)
  }

  return (
    <section className="teams-page">
      
      <div className="dashboard-card dashboard-card--wide teams-management-card">
        <h2 className="teams-management__title">Team management</h2>
        <p className="teams-management__desc">
          Manage your team members and their account permissions here.
        </p>
        <hr className="teams-management__divider" />

        <div className="teams-invite">
          <h3 className="teams-invite__title">Invite team members</h3>
          <p className="teams-invite__desc">
            Get your projects up and running faster by inviting your team to collaborate.
          </p>

          <div className="teams-invite__rows">
            {inviteRows.map((row) => (
              <div key={row.id} className="teams-invite__row">
                <div className="teams-invite__input-wrap">
                  <MdEmail className="teams-invite__input-icon" aria-hidden />
                  <input
                    type="email"
                    className="teams-invite__input"
                    placeholder="team@team.com"
                    value={row.email}
                    onChange={(e) => updateInviteRow(row.id, 'email', e.target.value)}
                  />
                </div>
                <select
                  className="teams-invite__select"
                  value={row.permission}
                  onChange={(e) => updateInviteRow(row.id, 'permission', e.target.value)}
                >
                  {PERMISSION_OPTIONS.map((opt) => (
                    <option key={opt} value={opt}>
                      {opt}
                    </option>
                  ))}
                </select>
              </div>
            ))}
          </div>

          <div className="teams-invite__footer">
            <button type="button" className="teams-invite__add" onClick={addInviteRow}>
              <MdAdd className="teams-invite__add-icon" aria-hidden />
              Add another
            </button>
            <button type="button" className="teams-invite__submit" onClick={handleSendInvites}>
              <MdEmail className="teams-invite__submit-icon" aria-hidden />
              Send invites
            </button>
          </div>
        </div>
      </div>

      {/* Team members list (below - unchanged) */}
      <div className="dashboard-card dashboard-card--wide teams-card">
        <header className="teams-card__header">
          <div>
            <h2 className="dashboard-card__title">Team members</h2>
            <p className="dashboard-card__subtitle">
              Get your projects up and running faster by inviting your team to collaborate.
            </p>
          </div>
        </header>

        <div className="teams-table">
          {members.map((member) => (
            <div key={member.id} className="teams-row">
              <div className="teams-row__select">
                <input type="checkbox" aria-label={`Select ${member.name}`} />
              </div>

              <div className="teams-row__identity">
                <div className="teams-avatar">
                  <span className="teams-avatar__initials">{member.initials}</span>
                </div>
                <div className="teams-row__text">
                  <div className="teams-row__name">{member.name}</div>
                  <div className="teams-row__email">{member.email}</div>
                </div>
              </div>

              <div className="teams-row__role">{member.role}</div>

              <div className="teams-row__actions">
                <button type="button" className="teams-row__action teams-row__action--danger">
                  Delete
                </button>
                <button type="button" className="teams-row__action teams-row__action--primary">
                  Edit
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}



export default Teams
