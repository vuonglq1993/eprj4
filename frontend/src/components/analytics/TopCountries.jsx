const countries = [
  { code: 'PK', name: 'Pakistan', value: '54%' },
  { code: 'DE', name: 'Germany', value: '32%' },
  { code: 'US', name: 'United State', value: '27%' },
  { code: 'ES', name: 'Spain', value: '25%' },
]

const FLAG_EMOJI = { PK: '🇵🇰', DE: '🇩🇪', US: '🇺🇸', ES: '🇪🇸' }

function TopCountries() {
  return (
    <article className="analytics-card">
      <h3 className="analytics-card__title">Top Countries</h3>
      <ul className="analytics-country-list">
        {countries.map(({ code, name, value }) => (
          <li key={code} className="analytics-country-item">
            <span className="analytics-country-item__flag">{FLAG_EMOJI[code]}</span>
            <span className="analytics-country-item__name">{name}</span>
            <span className="analytics-country-item__value">{value}</span>
          </li>
        ))}
      </ul>
    </article>
  )
}

export default TopCountries
