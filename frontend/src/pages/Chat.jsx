import React from 'react';
import { FiSearch, FiMoreVertical, FiPlay } from 'react-icons/fi';

const users = [
  { id: 1, name: "Jacob Jones", role: "Marketing Coordinator", time: "5m", img: "https://i.pravatar.cc/150?u=1" },
  { id: 2, name: "Leslie Alexander", role: "Web Designer", time: "5m", img: "https://i.pravatar.cc/150?u=2" },
  { id: 3, name: "Eleanor Pena", role: "Dog Trainer", time: "5m", img: "https://i.pravatar.cc/150?u=3" },
  { id: 4, name: "Kathryn Murphy", role: "Medical Assistant", time: "5m", img: "https://i.pravatar.cc/150?u=4" },
  { id: 5, name: "Wade Warren", role: "Web Designer", time: "5m", img: "https://i.pravatar.cc/150?u=5" },
  { id: 6, name: "Marvin McKinney", role: "Nursing Assistant", time: "5m", img: "https://i.pravatar.cc/150?u=6" },
];

const Chat = () => {
  return (
    <div className="chat-page">
      {/* Sidebar bên trái */}
      <div className="chat-sidebar">
        <div className="sidebar-header">
          <div className="search-wrapper">
            <input type="text" placeholder="Search" />
          </div>
        </div>
        <div className="user-list">
          {users.map(user => (
            <div key={user.id} className={`user-item ${user.id === 2 ? 'active' : ''}`}>
              <img src={user.img} alt={user.name} />
              <div className="user-info">
                <div className="name-row">
                  <h4>{user.name}</h4>
                  <span>{user.time}</span>
                </div>
                <p>{user.role}</p>
                <p className="last-msg">Lorem ipsum dolor sit amet</p>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Cửa sổ Chat bên phải */}
      <div className="chat-window">
        <header className="chat-header">
          <div className="current-user">
            <img src="https://i.pravatar.cc/150?u=10" alt="Mark David" />
            <div className="header-name">
              <h3>Mark David</h3>
              <p>markdavid@gmail.com</p>
            </div>
          </div>
          <div className="header-btns">
            <button className="btn-app">App</button>
            <button className="btn-msg">Message</button>
            <button className="btn-setting">Setting</button>
          </div>
        </header>

        <div className="chat-messages">
          <div className="date-divider">August 21</div>
          
          {/* Tin nhắn đến */}
          <div className="message incoming">
            <img src="https://i.pravatar.cc/150?u=2" alt="avatar" />
            <div className="msg-content">
              <div className="bubble">
                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Dolor mollis leo proin turpis eu hac. Tortor dolor eu at bibendum suspendisse.
              </div>
              <span className="msg-time">10:15 pm</span>
            </div>
          </div>

          {/* Tin nhắn đi */}
          <div className="message outgoing">
            <div className="msg-content">
              <div className="bubble">
                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Dolor mollis leo proin turpis eu hac. Tortor dolor eu at bibendum suspendisse.
              </div>
              <span className="msg-time">10:15 pm</span>
            </div>
            <img src="https://i.pravatar.cc/150?u=6" alt="avatar" />
          </div>

          {/* Tin nhắn thoại (Voice message) */}
          <div className="message incoming">
            <img src="https://i.pravatar.cc/150?u=2" alt="avatar" />
            <div className="msg-content">
              <div className="bubble voice">
                <FiPlay className="play-icon" />
                <div className="wave-container">
                  <div className="wave-bar active" style={{ height: '20px' }}></div>
                  <div className="wave-bar active" style={{ height: '30px' }}></div>
                  <div className="wave-bar" style={{ height: '25px' }}></div>
                  <div className="wave-bar" style={{ height: '15px' }}></div>
                  <span className="duration">0:56</span>
                </div>
              </div>
              <span className="msg-time">06:00 pm</span>
            </div>
          </div>
        </div>

        <footer className="chat-input-area">
          <div className="input-box">
            <input type="text" placeholder="Write a message..." />
          </div>
        </footer>
      </div>
    </div>
  );
};

export default Chat;