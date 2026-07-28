# Salone Web Admin Dashboard

Professional web dashboard for salon management built with Next.js 14, TypeScript, and Tailwind CSS.

## Tech Stack

- **Next.js 14** - React framework with file-based routing
- **TypeScript** - Type-safe development
- **Tailwind CSS** - Utility-first styling
- **TanStack Query** - Data fetching and caching
- **Axios** - HTTP client
- **Zustand** - State management

## Getting Started

### Prerequisites
- Node.js 18+
- npm or yarn

### Installation

```bash
cd web-admin
npm install
cp .env.example .env.local
```

### Development

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

### Build

```bash
npm run build
npm run start
```

## Environment Variables

```env
NEXT_PUBLIC_API_URL=http://localhost:3000
```

## Project Structure

```
app/
├── layout.tsx          # Root layout
├── globals.css         # Global styles
└── page.tsx            # Home page
components/
├── Sidebar.tsx         # Navigation sidebar
├── TopBar.tsx          # Top navigation bar
└── ...
lib/
├── api.ts              # API client
├── queries.ts          # React Query hooks
└── store.ts            # Zustand store
types/
└── index.ts            # TypeScript types
```

## Design System

### Colors (v4.1)
- **Primary**: #1B8A8A (Teal)
- **Primary Dark**: #0D5C5C
- **Primary Light**: #E8F4F8
- **Success**: #2D7D46
- **Danger**: #D32F2F
- **Warning**: #F9A825

### Typography
- **Font**: System font stack (Inter, Segoe UI, etc.)
- **Sizes**: Responsive using Tailwind scale

## Features

- 📊 Dashboard with KPI cards
- 📅 Bookings management
- 👥 Staff management
- 📈 Insights and analytics
- ✂️ Services catalog
- 📦 Inventory tracking
- 💼 Account management

## Building

See `docs/WEB_ADMIN_APP_PLAN.md` for the complete feature roadmap and architecture decisions.
