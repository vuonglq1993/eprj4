import { MdPhoneIphone, MdComputer, MdTablet, MdTv } from 'react-icons/md'

const devices = [
  { icon: MdPhoneIphone, label: 'Mobile', value: '96.42%' },
  { icon: MdComputer, label: 'Desktop', value: '2.76%' },
  { icon: MdTablet, label: 'Tablet', value: '0.82%' },
  { icon: MdTv, label: 'TV', value: '12.3%' },
]

function DeviceCategory() {
  return (
    <article className="analytics-card">
      <h3 className="analytics-card__title">Device Category</h3>
      <ul className="analytics-device-list">
        {devices.map(({ icon: Icon, label, value }) => (
          <li key={label} className="analytics-device-item">
            <span className="analytics-device-item__icon">
              <Icon size={20} />
            </span>
            <span className="analytics-device-item__label">{label}</span>
            <span className="analytics-device-item__value">{value}</span>
          </li>
        ))}
      </ul>
    </article>
  )
}

export default DeviceCategory
