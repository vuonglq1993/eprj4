import React from 'react';
import { FiSearch, FiMoreVertical } from 'react-icons/fi';
import { FaSlack, FaInvision, FaGithub } from 'react-icons/fa';

const AllProjects = () => {
    const projects = [
        {
            id: 1,
            title: 'Design tools',
            icon: (
                <div className="icon-box pink">
                    <span className="text-pink">Ic</span>
                </div>
            ),
            desc: 'Constantly growing. We’re constantly making mistakes from which we learn and improve',
            participants: 10,
            dueDate: '02.08.22',
            avatars: [
                'https://i.pravatar.cc/150?u=1',
                'https://i.pravatar.cc/150?u=2',
                'https://i.pravatar.cc/150?u=3',
                'https://i.pravatar.cc/150?u=4'
            ]
        },
        {
            id: 2,
            title: 'Premium Support',
            icon: (
                <div className="icon-box blue-dark">
                    <FaGithub />
                </div>
            ),
            desc: 'Pink is obviously a better color. Everyone born confident and everything taken away.',
            participants: 23,
            dueDate: '07.08.22',
            avatars: [
                'https://i.pravatar.cc/150?u=5',
                'https://i.pravatar.cc/150?u=6',
                'https://i.pravatar.cc/150?u=7'
            ]
        },
        {
            id: 3,
            title: 'Slack Bot',
            icon: (
                <div className="icon-box light-pink">
                    <FaSlack />
                </div>
            ),
            desc: 'If everything I did failed which it doesn’t I think that it actually succeeds.',
            participants: 11,
            dueDate: '10.08.22',
            avatars: [
                'https://i.pravatar.cc/150?u=8',
                'https://i.pravatar.cc/150?u=9'
            ]
        },
        {
            id: 4,
            title: 'Developer First',
            icon: (
                <div className="icon-box indigo-bg text-white">
                    <FaInvision />
                </div>
            ),
            desc: 'For standing out. But the time is now to be okay to be the greatest you.',
            participants: 30,
            dueDate: '20.08.22',
            avatars: [
                'https://i.pravatar.cc/150?u=10',
                'https://i.pravatar.cc/150?u=11',
                'https://i.pravatar.cc/150?u=12'
            ]
        },
        {
            id: 5,
            title: 'Looking great',
            icon: (
                <div className="icon-box orange-bg text-white">
                    <FaGithub />
                </div>
            ),
            desc: 'You have the opportunity to play this game of life you need to appreciate every moment.',
            participants: 30,
            dueDate: '20.08.22',
            avatars: [
                'https://i.pravatar.cc/150?u=13',
                'https://i.pravatar.cc/150?u=14'
            ]
        },
    ];

    return (
        <div className="all-projects-page">
            <div className="main-white-card main-content-wrapper">
                <div className="user-info-bar d-flex justify-content-between align-items-center mb-4">
                    <div className="user-profile d-flex align-items-center gap-3">
                        <img
                            src="https://i.pravatar.cc/150?u=sayokravits"
                            alt="Sayo Kravits"
                            className="user-avatar-rect"
                        />
                        <div>
                            <h4 className="user-name">Sayo Kravits</h4>
                            <p className="user-role">Public Relations</p>
                        </div>
                    </div>
                    <div className="action-tabs d-flex gap-2">
                        <button className="tab-btn active">App</button>
                        <button className="tab-btn outline">Messages</button>
                        <button className="tab-btn outline">Settings</button>
                    </div>
                </div>
                <div className="projects-grid-container">
                    <div className="section-header-gray">
                        <h5>Some of Our Awesome projects</h5>
                    </div>

                    <div className="row g-4 mt-1">
                        {projects.map((project) => (
                            <div key={project.id} className="col-md-6 col-lg-4">
                                <div className="project-card-item h-100">
                                    <div className="d-flex justify-content-between align-items-start mb-3">
                                        <div className="d-flex align-items-center gap-3">
                                            {project.icon}
                                            <h6 className="project-title mb-0">{project.title}</h6>
                                        </div>
                                        <FiMoreVertical className="more-icon-btn" />
                                    </div>

                                    <div className="avatar-group-stack mb-3">
                                        {project.avatars.map((av) => (
                                            <img key={av} src={av} alt="participant" />
                                        ))}
                                    </div>

                                    <p className="project-description-text">{project.desc}</p>

                                    <hr className="card-divider" />

                                    <div className="d-flex justify-content-between mt-3">
                                        <div className="info-item">
                                            <span className="info-value">{project.participants}</span>
                                            <span className="info-subtitle">Participants</span>
                                        </div>
                                        <div className="info-item text-end">
                                            <span className="info-value">{project.dueDate}</span>
                                            <span className="info-subtitle">Due date</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        ))}

                        {/* Empty 'New Project' Card */}
                        <div key="new-project" className="col-md-6 col-lg-4">
                            <div className="empty-new-project-btn d-flex align-items-center justify-content-center">
                                <span>New project</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default AllProjects;
