import React from 'react';
import '../styles/Timeline.css';

import { MdNotifications, MdPhoneIphone, MdLockOpen, MdEmail } from 'react-icons/md';
import { FaPaypal, FaFileAlt } from 'react-icons/fa';

const timelineData = [
  {
    id: 1,
    title: '$8900, Design changes',
    time: '12 DEC 9:00 PM',
    desc: 'People care about how you see the world, how you think, what motivates you, what you\'re struggling with or afraid of.',
    tags: ['Design'],
    icon: <MdNotifications />,
    color: '#6366f1'
  },
  {
    id: 2,
    title: 'New order #1832412',
    time: '21 DEC 11 PM',
    desc: 'People care about how you see the world, how you think, what motivates you, what you\'re struggling with or afraid of.',
    tags: ['ORDER', '#1832'],
    icon: <MdPhoneIphone />,
    color: '#0ea5e9'
  },
  {
    id: 3,
    title: 'Server payments for April',
    time: '21 DEC 9:34 PM',
    desc: 'People care about how you see the world, how you think, what motivates you, what you\'re struggling with or afraid of.',
    tags: ['Server', 'Pyment'],
    icon: <FaPaypal />,
    color: '#3b82f6'
  },
  {
    id: 4,
    title: 'New card added for order #4395133',
    time: '20 DEC 2:20 AM',
    desc: 'People care about how you see the world, how you think, what motivates you, what you\'re struggling with or afraid of.',
    tags: ['CARD', '#439'],
    icon: <FaFileAlt />,
    color: '#a855f7'
  },
  {
    id: 5,
    title: 'Unlock packages for development',
    time: '18 DEC 4:54 AM',
    desc: 'People care about how you see the world, how you think, what motivates you, what you\'re struggling with or afraid of.',
    tags: ['Decelop'],
    icon: <MdLockOpen />,
    color: '#ef4444'
  },
  {
    id: 6,
    title: 'New message unread',
    time: '16 DEC',
    desc: 'People care about how you see the world, how you think, what motivates you, what you\'re struggling with or afraid of.',
    tags: ['Message'],
    icon: <MdEmail />,
    color: '#8b5cf6'
  }
];

const TimelineItem = ({ item }) => (
  
  <div className="timeline-item">
    <div className="timeline-line"></div>
    <div className="timeline-icon" style={{ backgroundColor: item.color }}>
      {item.icon}
    </div>
    <div className="timeline-content">
      <div className="timeline-header">
        <h3>{item.title}</h3>
        <span className="timeline-time">{item.time}</span>
      </div>
      <p className="timeline-desc">{item.desc}</p>
      <div className="timeline-tags">
        {item.tags.map(tag => (
          <span key={tag} className="tag" style={{ backgroundColor: item.color + '22', color: item.color }}>
            {tag}
          </span>
        ))}
      </div>
    </div>
  </div>
);

const TimelinePage = () => {
  return (
    <div className="timeline-container">
      <div className="timeline-section light-theme">
        <h2 className="section-title">Timeline with dotted line</h2>
        <div className="timeline-list">
          {timelineData.map(item => <TimelineItem key={item.id} item={item} />)}
        </div>
      </div>

      <div className="timeline-section dark-theme">
        <h2 className="section-title">Timeline with dotted line</h2>
        <div className="timeline-list">
          {timelineData.map(item => <TimelineItem key={item.id} item={item} />)}
        </div>
      </div>
    </div>
  );
};

export default TimelinePage;