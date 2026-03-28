import React, { useState } from 'react';
import {
    FiSearch, FiCalendar, FiFilter, FiMoreHorizontal,
    FiPaperclip, FiMessageSquare, FiPlus, FiShare2
} from 'react-icons/fi';

const Kanban = () => {
    const [tasks] = useState([
        { id: 1, title: 'Webdev', team: 'Cisco Team', days: 12, files: 7, comments: 8, status: 'todo' },
        { id: 2, title: 'Cloud computing', team: 'Gento Team', days: 31, files: 2, comments: 0, status: 'in-progress' },
        { id: 3, title: 'Landing page', team: 'Design Team', days: 11, files: 7, comments: 8, status: 'in-progress' },
        { id: 4, title: 'Update subscription', team: 'Developing Team', days: 15, files: 0, comments: 0, status: 'in-progress' },
        { id: 5, title: 'Food app design', team: 'Design Team', days: 21, files: 0, comments: 0, status: 'in-progress' },
    ]);

    return (
        <div className="kanban-page p-4">
            <header className="kanban-header d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 className="fw-bold mb-1">Overview</h2>
                    <p className="text-muted small">Edit or modify all card as you want</p>
                </div>
                <div className="team-section d-flex align-items-center">
                    <span className="me-3 fw-semibold small text-secondary">Teams Members:</span>
                    <div className="avatar-stack d-flex me-3">
                        <img src="https://i.pravatar.cc/150?u=1" alt="user" />
                        <img src="https://i.pravatar.cc/150?u=2" alt="user" />
                        <img src="https://i.pravatar.cc/150?u=3" alt="user" />
                        <img src="https://i.pravatar.cc/150?u=4" alt="user" />
                    </div>
                    <button className="btn-share-icon"><FiShare2 /></button>
                </div>
            </header>

            <div className="kanban-filters d-flex gap-3 mb-4 align-items-center">
                <div className="search-box position-relative flex-grow-1">
                    <FiSearch className="icon-left" />
                    <input
                        type="text"
                        placeholder="Search projects..."
                        className="custom-input"
                    />
                </div>
                <div className="date-box position-relative">
                    <FiCalendar className="icon-left" />
                    <input
                        type="date"
                        className="custom-input date-input"
                    />
                </div>
                <button className="btn-filter">
                    <FiFilter className="me-2" />
                    Filter
                </button>
            </div>
            <div className="kanban-board-row row g-4 flex-nowrap overflow-auto pb-3">

                <div className="col-lg-4 kanban-col">
                    <div className="column-wrapper p-3">
                        <div className="d-flex justify-content-between align-items-center mb-3">
                            <h6 className="column-title">To Do task</h6>
                            <FiMoreHorizontal className="text-muted cursor-pointer" />
                        </div>
                        <div className="btn-add-task-dash mb-3">
                            <FiPlus />
                        </div>
                        {tasks.filter(t => t.status === 'todo').map(task => <TaskItem key={task.id} task={task} />)}
                    </div>
                </div>

                <div className="col-lg-4 kanban-col">
                    <div className="column-wrapper p-3 border-top-purple">
                        <div className="d-flex justify-content-between align-items-center mb-3">
                            <h6 className="column-title">In Progress</h6>
                            <FiMoreHorizontal className="text-muted cursor-pointer" />
                        </div>
                        {tasks.filter(t => t.status === 'in-progress').slice(0, 2).map(task => <TaskItem key={task.id} task={task} />)}
                    </div>
                </div>

                <div className="col-lg-4 kanban-col">
                    <div className="column-wrapper p-3 border-top-purple">
                        <div className="d-flex justify-content-between align-items-center mb-3">
                            <h6 className="column-title">In Progress</h6>
                            <FiMoreHorizontal className="text-muted cursor-pointer" />
                        </div>
                        {tasks.filter(t => t.status === 'in-progress').slice(2, 4).map(task => <TaskItem key={task.id} task={task} />)}
                    </div>
                </div>
            </div>

            {/* Pagination - Professional Style */}
            <footer className="kanban-footer d-flex justify-content-center mt-5">
                <nav>
                    <ul className="pagination custom-pagination-ui">
                        <li className="page-item disabled"><a className="page-link" href="#prev">Previous</a></li>
                        <li className="page-item active"><a className="page-link" href="#1">1</a></li>
                        <li className="page-item"><a className="page-link" href="#2">2</a></li>
                        <li className="page-item"><a className="page-link" href="#3">3</a></li>
                        <li className="page-item"><a className="page-link" href="#next">Next</a></li>
                    </ul>
                </nav>
            </footer>
        </div>
    );
};

const TaskItem = ({ task }) => (
    <div className="task-card-ui p-3 shadow-sm mb-3">
        <div className="d-flex justify-content-between align-items-start mb-2">
            <h6 className="task-name">{task.title}</h6>
            <div className="task-time-badge d-flex align-items-center">
                <span className="clock-dot me-1"></span>
                {task.days} Days
            </div>
        </div>
        <div className="task-team-info mb-3">
            <FiShare2 size={12} className="me-1" /> {task.team}
        </div>
        <div className="d-flex justify-content-between align-items-center">
            <div className="task-stats d-flex gap-3">
                <span><FiPaperclip size={14} /> {task.files}</span>
                <span><FiMessageSquare size={14} /> {task.comments}</span>
            </div>
            <div className="task-avatars d-flex align-items-center">
                <div className="add-user-btn-small me-1"><FiPlus size={12} /></div>
                <img src="https://i.pravatar.cc/100?u=task1" alt="tm" className="small-av" />
                <img src="https://i.pravatar.cc/100?u=task2" alt="tm" className="small-av" />
            </div>
        </div>
    </div>
);

export default Kanban;