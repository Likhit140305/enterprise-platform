import React from 'react';
import { Link, Outlet, useLocation } from 'react-router-dom';

const Layout = () => {
    const location = useLocation();

    const isActive = (path) => {
        return location.pathname.startsWith(path) ? 'bg-red-700 text-white' : 'text-gray-300 hover:bg-gray-800';
    };

    return (
        <div className="min-h-screen bg-gray-100 flex flex-col">
            {/* Header */}
            <header className="bg-gray-900 text-white shadow-lg">
                <div className="container mx-auto px-6 py-4 flex justify-between items-center">
                    <div className="flex items-center space-x-4">
                        <div className="text-2xl font-bold tracking-tight text-red-600">ORACLE</div>
                        <div className="text-sm text-gray-400 border-l border-gray-700 pl-4">
                            Enterprise Intelligence Platform
                        </div>
                    </div>
                    <nav className="flex space-x-4">
                        <Link
                            to="/hr"
                            className={`px-4 py-2 rounded-md text-sm font-medium transition-colors ${isActive('/hr')}`}
                        >
                            HR & Payroll
                        </Link>
                        <Link
                            to="/security"
                            className={`px-4 py-2 rounded-md text-sm font-medium transition-colors ${isActive('/security')}`}
                        >
                            Security Analytics
                        </Link>
                    </nav>
                </div>
            </header>

            {/* Main Content */}
            <main className="flex-grow container mx-auto px-6 py-8">
                <Outlet />
            </main>

            {/* Footer */}
            <footer className="bg-gray-200 border-t border-gray-300 mt-auto">
                <div className="container mx-auto px-6 py-4 text-center text-gray-600 text-sm">
                    &copy; {new Date().getFullYear()} Oracle Corporation (Demo Portfolio). Powered by Oracle Autonomous Database.
                </div>
            </footer>
        </div>
    );
};

export default Layout;
