import React from 'react';
import { FiMoreVertical, FiSearch, FiFilter, FiDownload } from 'react-icons/fi';

const DataTables = () => {
    const users = [
        { name: 'Tiger Nixon', position: 'System Architect', age: 61, office: 'Tokyo', salary: '$170,750', startDate: '22/5/2009', avatar: 'https://i.pravatar.cc/150?u=1' },
        { name: 'Garrett Winters', position: 'Accountant', age: 63, office: 'San Francisco', salary: '$433,060', startDate: '22/5/2011', avatar: 'https://i.pravatar.cc/150?u=2' },
        { name: 'Ashton Cox', position: 'Technical Author', age: 66, office: 'Edinburgh', salary: '$320,800', startDate: '25/5/2011', avatar: 'https://i.pravatar.cc/150?u=3' },
        { name: 'Tiger Nixon', position: 'Javascript Developer', age: 22, office: 'Tokyo', salary: '$170,750', startDate: '22/5/2012', avatar: 'https://i.pravatar.cc/150?u=4' },
        { name: 'Cedric Kelly', position: 'Integration Specialist', age: 31, office: 'New York', salary: '$86,000', startDate: '22/5/2012', avatar: 'https://i.pravatar.cc/150?u=5' },
        { name: 'Airi Satou', position: 'Sales Assistant', age: 45, office: 'Edinburgh', salary: '$433,060', startDate: '30/5/2009', avatar: 'https://i.pravatar.cc/150?u=6' },
        { name: 'Brielle Williamson', position: 'Integration Specialist', age: 19, office: 'Berlin', salary: '$162,700', startDate: '22/5/2015', avatar: 'https://i.pravatar.cc/150?u=7' },
        { name: 'Herrod Chandler', position: 'Javascript Developer', age: 61, office: 'Islamabad', salary: '$372,000', startDate: '28/5/2016', avatar: 'https://i.pravatar.cc/150?u=8' },
    ];

    return (
        <div className="datatables-page p-4">

            {/* Table Section */}
            <div className="table-card shadow-sm">
                <div className="table-responsive">
                    <table className="table custom-table mb-0">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Position</th>
                                <th>Age</th>
                                <th>Office</th>
                                <th>Salary</th>
                                <th>Start date</th>
                                <th className="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            {users.map((user, index) => (
                                <tr key={index}>
                                    <td>
                                        <div className="d-flex align-items-center">
                                            <img src={user.avatar} alt="avatar" className="user-avatar me-3" />
                                            <span className="fw-semibold text-dark">{user.name}</span>
                                        </div>
                                    </td>
                                    <td><span className="text-muted">{user.position}</span></td>
                                    <td>{user.age}</td>
                                    <td>{user.office}</td>
                                    <td><span className="fw-bold text-dark">{user.salary}</span></td>
                                    <td>{user.startDate}</td>
                                    <td className="text-center">
                                        <button className="btn-more"><FiMoreVertical /></button>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    );
};

export default DataTables;