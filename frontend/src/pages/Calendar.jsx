import React, { useState } from 'react';
import { FiChevronLeft, FiChevronRight, FiCalendar, FiMoreVertical } from 'react-icons/fi';

// Ví dụ dữ liệu sự kiện
const sidebarEvents = [
  { title: 'Festival', loc: 'Berlin', date: '2026-03-01', type: 'purple' },
  { title: 'Exam', loc: 'France', date: '2026-03-12', type: 'green' },
  { title: 'Eid festival', loc: 'Germany', date: '2026-03-15', type: 'blue' },
  { title: 'Conference', loc: 'UK', date: '2026-03-20', type: 'red' },
];

const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

const Calendar = () => {
  const today = new Date();
  const [currentDate, setCurrentDate] = useState(new Date(today.getFullYear(), today.getMonth(), 1));
  const [viewMode, setViewMode] = useState('Month'); // Month | Week | Day

  // Chuyển tháng
  const changeMonth = (dir) => {
    const newDate = new Date(currentDate);
    newDate.setMonth(currentDate.getMonth() + dir);
    setCurrentDate(newDate);
  };

  // Chuyển năm
  const changeYear = (dir) => {
    const newDate = new Date(currentDate);
    newDate.setFullYear(currentDate.getFullYear() + dir);
    setCurrentDate(newDate);
  };

  const daysInMonth = (year, month) => new Date(year, month + 1, 0).getDate();

  const monthStartDay = currentDate.getDay();
  const totalDays = daysInMonth(currentDate.getFullYear(), currentDate.getMonth());

  const monthName = currentDate.toLocaleString('default', { month: 'long' });
  const year = currentDate.getFullYear();

  // Lọc sự kiện trong tháng
  const eventsThisMonth = sidebarEvents.filter(ev => {
    const evDate = new Date(ev.date);
    return evDate.getMonth() === currentDate.getMonth() && evDate.getFullYear() === currentDate.getFullYear();
  });

  return (
    <div className="calendar-page d-flex p-4 gap-4">
      {/* Sidebar */}
      <div className="calendar-sidebar">
        <h4 className="fw-bold mb-1">Details Day</h4>
        <p className="text-muted small mb-4">Don't miss scheduled events</p>
        <div className="event-list">
          {eventsThisMonth.map((event, idx) => (
            <div key={idx} className="event-card mb-3 p-3 shadow-sm border-0">
              <div className="d-flex justify-content-between align-items-start">
                <div>
                  <h6 className="fw-bold mb-0">{event.title}</h6>
                  <p className="text-muted smaller mb-2">{event.loc}</p>
                </div>
                <span className={`badge-time ${event.type}`}>All Day</span>
              </div>
              <div className="d-flex align-items-center text-muted smaller mt-2">
                <FiCalendar className="me-2" /> {event.date}
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Main Calendar */}
      <div className="calendar-main flex-grow-1 p-4 shadow-sm">
        <div className="d-flex justify-content-between align-items-center mb-4">
          <div className="d-flex align-items-center gap-3">
            <button className="nav-btn" onClick={() => viewMode === 'Month' ? changeMonth(-1) : changeYear(-1)}>
              <FiChevronLeft />
            </button>
            <h4 className="fw-bold mb-0">
              {monthName} {year}
            </h4>
            <button className="nav-btn" onClick={() => viewMode === 'Month' ? changeMonth(1) : changeYear(1)}>
              <FiChevronRight />
            </button>
          </div>

          <div className="d-flex align-items-center gap-3">
            <button className="btn-today" onClick={() => setCurrentDate(new Date(today.getFullYear(), today.getMonth(), 1))}>
              Today
            </button>
            <div className="sort-by small">
              Sort By: 
              <select
                className="fw-bold ms-1"
                value={viewMode}
                onChange={(e) => setViewMode(e.target.value)}
              >
                <option value="Month">Month</option>
                <option value="Week">Week</option>
                <option value="Day">Day</option>
              </select>
            </div>
            <FiMoreVertical className="text-muted cursor-pointer" />
          </div>
        </div>

        {/* Grid Month */}
        {viewMode === 'Month' && (
          <div className="calendar-grid">
            {days.map(day => (
              <div key={day} className="grid-header text-muted small py-3">{day}</div>
            ))}

            {Array.from({ length: monthStartDay }).map((_, i) => (
              <div key={`empty-${i}`} className="grid-cell p-2" />
            ))}

            {Array.from({ length: totalDays }).map((_, i) => {
              const dayNum = i + 1;
              const eventToday = eventsThisMonth.find(ev => new Date(ev.date).getDate() === dayNum);
              return (
                <div key={i} className="grid-cell p-2">
                  <span className={`day-number ${dayNum === today.getDate() && currentDate.getMonth() === today.getMonth() ? 'active' : ''}`}>
                    {dayNum}
                  </span>
                  {eventToday && <div className={`event-strip ${eventToday.type}`}>{eventToday.title}</div>}
                </div>
              );
            })}
          </div>
        )}

        {/* TODO: Week/Day view */}
        {viewMode === 'Week' && <div className="text-center text-muted">Week view coming soon...</div>}
        {viewMode === 'Day' && <div className="text-center text-muted">Day view coming soon...</div>}
      </div>
    </div>
  );
};

export default Calendar;
