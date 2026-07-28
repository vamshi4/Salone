import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { useEffect, useState } from 'react';
import { useAppStore } from './stores/appStore';
import { useGetMe } from './api/queries';

import Sidebar from './components/Sidebar';
import TopBar from './components/TopBar';
import Home from './pages/Home';
import NotFound from './pages/NotFound';

const queryClient = new QueryClient();

function AppContent() {
  const [sidebarOpen, setSidebarOpen] = useState(true);
  const { data, isLoading } = useGetMe();
  const setUser = useAppStore((state) => state.setUser);
  const setSalons = useAppStore((state) => state.setSalons);

  useEffect(() => {
    if (data) {
      setUser(data.user);
      setSalons(data.salons);
    }
  }, [data, setUser, setSalons]);

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <p className="text-text-muted">Loading...</p>
      </div>
    );
  }

  return (
    <div className="flex h-screen bg-main">
      <Sidebar isOpen={sidebarOpen} onClose={() => setSidebarOpen(false)} />
      <div className="flex-1 flex flex-col overflow-hidden">
        <TopBar onMenuClick={() => setSidebarOpen(!sidebarOpen)} />
        <main className="flex-1 overflow-y-auto">
          <Routes>
            <Route path="/home" element={<Home />} />
            <Route path="/bookings" element={<div className="p-6">Bookings Page - Coming Soon</div>} />
            <Route path="/staff" element={<div className="p-6">Staff Page - Coming Soon</div>} />
            <Route path="/services" element={<div className="p-6">Services Page - Coming Soon</div>} />
            <Route path="/inventory" element={<div className="p-6">Inventory Page - Coming Soon</div>} />
            <Route path="/insights" element={<div className="p-6">Insights Page - Coming Soon</div>} />
            <Route path="/payouts" element={<div className="p-6">Payouts Page - Coming Soon</div>} />
            <Route path="/booking-link" element={<div className="p-6">Booking Link Page - Coming Soon</div>} />
            <Route path="/" element={<Navigate to="/home" replace />} />
            <Route path="*" element={<NotFound />} />
          </Routes>
        </main>
      </div>
    </div>
  );
}

export default function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <Router>
        <AppContent />
      </Router>
    </QueryClientProvider>
  );
}
