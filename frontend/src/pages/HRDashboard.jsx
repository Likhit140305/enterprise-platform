import React, { useState, useEffect } from 'react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

const HRDashboard = () => {
    const [employees, setEmployees] = useState([]);
    const [salaryReport, setSalaryReport] = useState([]);
    const [loading, setLoading] = useState(true);

    // Mock API Call simulation
    useEffect(() => {
        const fetchData = async () => {
            try {
                // In a real app, fetch from http://localhost:8000/api/hr/employees
                const empRes = await fetch('http://localhost:8000/api/hr/employees');
                const empData = await empRes.json();
                setEmployees(empData);

                const salRes = await fetch('http://localhost:8000/api/hr/reports/salary');
                const salData = await salRes.json();
                setSalaryReport(salData);
            } catch (error) {
                console.error("Failed to fetch data", error);
            } finally {
                setLoading(false);
            }
        };

        fetchData();
    }, []);

    const handleCalculatePayroll = async () => {
        alert("Triggering Payroll Calculation Procedure (PL/SQL)...");
        await fetch('http://localhost:8000/api/hr/payroll/calculate?month=2023-10', { method: 'POST' });
        alert("Payroll Calculated Successfully!");
    };

    if (loading) return <div className="text-center mt-20">Loading HR Data...</div>;

    return (
        <div className="space-y-8">
            <div className="flex justify-between items-center">
                <h1 className="text-3xl font-bold text-gray-800">HR & Payroll Management</h1>
                <button
                    onClick={handleCalculatePayroll}
                    className="bg-red-600 hover:bg-red-700 text-white px-6 py-2 rounded shadow transition"
                >
                    Run Payroll Process
                </button>
            </div>

            {/* Stats Cards */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div className="bg-white p-6 rounded-lg shadow-md border-t-4 border-blue-500">
                    <h3 className="text-gray-500 text-sm font-medium uppercase">Total Employees</h3>
                    <p className="text-3xl font-bold text-gray-800 mt-2">{employees.length}</p>
                </div>
                <div className="bg-white p-6 rounded-lg shadow-md border-t-4 border-green-500">
                    <h3 className="text-gray-500 text-sm font-medium uppercase">Active Departments</h3>
                    <p className="text-3xl font-bold text-gray-800 mt-2">3</p>
                </div>
                <div className="bg-white p-6 rounded-lg shadow-md border-t-4 border-purple-500">
                    <h3 className="text-gray-500 text-sm font-medium uppercase">Pending Leave Requests</h3>
                    <p className="text-3xl font-bold text-gray-800 mt-2">5</p>
                </div>
            </div>

            {/* Employee Table */}
            <div className="bg-white rounded-lg shadow overflow-hidden">
                <div className="px-6 py-4 border-b border-gray-200 bg-gray-50">
                    <h2 className="text-lg font-semibold text-gray-700">Employee Directory</h2>
                </div>
                <table className="min-w-full divide-y divide-gray-200">
                    <thead className="bg-gray-50">
                        <tr>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Role</th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Email</th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                        </tr>
                    </thead>
                    <tbody className="bg-white divide-y divide-gray-200">
                        {employees.map((emp) => (
                            <tr key={emp.emp_id}>
                                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">#{emp.emp_id}</td>
                                <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{emp.name}</td>
                                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{emp.role}</td>
                                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{emp.email}</td>
                                <td className="px-6 py-4 whitespace-nowrap">
                                    <span className="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                        {emp.status}
                                    </span>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>

            {/* Salary Chart */}
            <div className="bg-white p-6 rounded-lg shadow">
                <h2 className="text-lg font-semibold text-gray-700 mb-4">Monthly Salary Distribution</h2>
                <div className="h-64">
                    <ResponsiveContainer width="100%" height="100%">
                        <BarChart data={salaryReport}>
                            <CartesianGrid strokeDasharray="3 3" />
                            <XAxis dataKey="name" />
                            <YAxis />
                            <Tooltip />
                            <Legend />
                            <Bar dataKey="gross_salary" fill="#8884d8" name="Gross Salary" />
                            <Bar dataKey="net_salary" fill="#82ca9d" name="Net Salary" />
                        </BarChart>
                    </ResponsiveContainer>
                </div>
            </div>
        </div>
    );
};

export default HRDashboard;
