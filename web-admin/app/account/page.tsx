'use client';

import { PageLayout } from '@/components/PageLayout';
import { Save, User, Lock, Globe, Bell } from 'lucide-react';
import { useState } from 'react';

export default function AccountPage() {
  const [activeTab, setActiveTab] = useState('profile');

  const tabs = [
    { id: 'profile', label: 'Profile', icon: User },
    { id: 'security', label: 'Security', icon: Lock },
    { id: 'preferences', label: 'Preferences', icon: Globe },
    { id: 'notifications', label: 'Notifications', icon: Bell },
  ];

  return (
    <PageLayout
      title="Account Settings"
      subtitle="Manage your account and preferences"
    >
      {/* Tabs */}
      <div className="flex gap-1 bg-gray-100 p-0.5 rounded-md w-fit">
        {tabs.map((tab) => {
          const Icon = tab.icon;
          return (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={`flex items-center gap-1.5 px-3 py-1.5 rounded font-medium text-xs transition-colors ${
                activeTab === tab.id
                  ? 'bg-white text-gray-900 shadow-sm'
                  : 'text-gray-500 hover:text-gray-900'
              }`}
            >
              <Icon size={13} />
              {tab.label}
            </button>
          );
        })}
      </div>

      {/* Content */}
      {activeTab === 'profile' && (
        <div className="card p-6 space-y-6">
          <div className="flex items-center gap-4">
            <div className="w-14 h-14 bg-primary-light rounded-full flex items-center justify-center text-primary-dark text-xl font-medium">
              P
            </div>
            <div>
              <p className="text-sm font-medium text-gray-900">Priya Sharma</p>
              <p className="text-xs text-gray-400">Salon owner</p>
              <button className="text-xs text-primary font-medium mt-1 hover:underline">Change avatar</button>
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 pt-4 border-t border-gray-200">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">First Name</label>
              <input
                type="text"
                defaultValue="Priya"
                className="w-full px-3 py-2 border border-gray-300 rounded-lg"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Last Name</label>
              <input
                type="text"
                defaultValue="Sharma"
                className="w-full px-3 py-2 border border-gray-300 rounded-lg"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Email</label>
              <input
                type="email"
                defaultValue="priya@salone.com"
                className="w-full px-3 py-2 border border-gray-300 rounded-lg"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Phone</label>
              <input
                type="tel"
                defaultValue="9876543210"
                className="w-full px-3 py-2 border border-gray-300 rounded-lg"
              />
            </div>
          </div>

          <button className="btn-primary flex items-center gap-2 mt-4">
            <Save size={16} />
            Save Changes
          </button>
        </div>
      )}

      {activeTab === 'security' && (
        <div className="card p-6 space-y-6">
          <div>
            <h3 className="text-lg font-bold text-gray-900 mb-4">Change Password</h3>
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Current Password</label>
                <input
                  type="password"
                  placeholder="Enter current password"
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">New Password</label>
                <input
                  type="password"
                  placeholder="Enter new password"
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Confirm Password</label>
                <input
                  type="password"
                  placeholder="Confirm new password"
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                />
              </div>
              <button className="btn-primary">Update Password</button>
            </div>
          </div>
        </div>
      )}

      {activeTab === 'preferences' && (
        <div className="card p-6 space-y-6">
          <h3 className="text-lg font-bold text-gray-900">Preferences</h3>
          <div className="space-y-4">
            <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
              <div>
                <p className="font-medium text-gray-900">Language</p>
                <p className="text-sm text-gray-600">English</p>
              </div>
              <select className="px-3 py-2 border border-gray-300 rounded-lg">
                <option>English</option>
                <option>Hindi</option>
              </select>
            </div>
            <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
              <div>
                <p className="font-medium text-gray-900">Timezone</p>
                <p className="text-sm text-gray-600">Asia/Kolkata (IST)</p>
              </div>
              <select className="px-3 py-2 border border-gray-300 rounded-lg">
                <option>Asia/Kolkata</option>
                <option>UTC</option>
              </select>
            </div>
          </div>
        </div>
      )}

      {activeTab === 'notifications' && (
        <div className="card p-6 space-y-6">
          <h3 className="text-lg font-bold text-gray-900">Notification Preferences</h3>
          <div className="space-y-4">
            {[
              { title: 'Email Notifications', desc: 'Receive updates via email' },
              { title: 'SMS Alerts', desc: 'Get important alerts via SMS' },
              { title: 'Push Notifications', desc: 'Receive app notifications' },
              { title: 'Marketing Emails', desc: 'Receive promotional emails' },
            ].map((notif, idx) => (
              <div key={idx} className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                <div>
                  <p className="font-medium text-gray-900">{notif.title}</p>
                  <p className="text-sm text-gray-600">{notif.desc}</p>
                </div>
                <input type="checkbox" defaultChecked className="w-5 h-5 text-primary rounded" />
              </div>
            ))}
          </div>
        </div>
      )}
    </PageLayout>
  );
}
