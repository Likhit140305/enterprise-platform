import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import Layout from './components/Layout';
import HRDashboard from './pages/HRDashboard';
import SecurityDashboard from './pages/SecurityDashboard';

function App() {
    return (
        <Router>
            <Routes>
                <Route path="/" element={<Layout />}>
                    <Route index element={<Navigate to="/hr" replace />} />
                    <Route path="hr" element={<HRDashboard />} />
                    <Route path="security" element={<SecurityDashboard />} />
                </Route>
            </Routes>
        </Router>
    );
}

export default App;
