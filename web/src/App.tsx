import { useEffect } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { QueryClientProvider, QueryClient } from '@tanstack/react-query';
import { Sidebar } from './components/Sidebar';
import { TopBar } from './components/TopBar';
import { BranchSwitcher } from './components/BranchSwitcher';
import { Home } from './pages/Home';
import { Bookings } from './pages/Bookings';
import { Staff } from './pages/Staff';
import { Insights } from './pages/Insights';
import { Services } from './pages/Services';
import { Inventory } from './pages/Inventory';
import { Account } from './pages/Account';
import { NotFound } from './pages/NotFound';
import { useAppStore } from './stores/appStore';
import { useGetMe } from './api/queries';

const queryClient = new QueryClient();

function AppContent() {
  const { data: meData } = useGetMe();
  const { setUser, setSalons } = useAppStore();

  useEffect(() => {
    if (meData?.user) {
      setUser(meData.user);
      setSalons(meData.salons);
    }
  }, [meData, setUser, setSalons]);

  const { sidebarOpen } = useAppStore();

  return (
    <div className="flex h-screen bg-salone-bg">
      {/* Sidebar */}
      <Sidebar />

      {/* Main Content */}
      <div className="flex-1 flex flex-col min-w-0">
        {/* Branch Switcher */}
        <BranchSwitcher />

        {/* Top Bar */}
        <TopBar />

        {/* Content */}
        <div
          className={`flex-1 overflow-y-auto px-3 py-3 transition-all ${
            sidebarOpen ? 'md:ml-0' : 'md:ml-0'
          }`}
        >
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/bookings" element={<Bookings />} />
            <Route path="/staff" element={<Staff />} />
            <Route path="/insights" element={<Insights />} />
            <Route path="/services" element={<Services />} />
            <Route path="/inventory" element={<Inventory />} />
            <Route path="/payouts" element={<NotFound />} />
            <Route path="/booking-link" element={<NotFound />} />
            <Route path="/account" element={<Account />} />
            <Route path="/help" element={<NotFound />} />
            <Route path="*" element={<NotFound />} />
          </Routes>
        </div>
      </div>
    </div>
  );
}

export function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <BrowserRouter>
        <AppContent />
      </BrowserRouter>
    </QueryClientProvider>
  );
}

export default App;
