# Salone Web Dashboard v4.1

Professional web dashboard for salon management built with v4.1 design system.

## Features

- 📊 Dashboard with KPI cards and real-time metrics
- 📅 Bookings management and calendar view
- 👥 Staff CRM with commission/salary tracking
- 📈 Insights with earnings analytics
- ✂️ Services catalog management
- 📦 Inventory tracking
- 🌿 Multi-branch support
- 🎨 Exact v4.1 design system (magenta accent #E91E76, clean white UI)

## Tech Stack

- React 18 + TypeScript
- React Router v6
- TailwindCSS (v4.1 custom theme)
- React Query for data fetching
- Recharts for analytics
- Zustand for state management
- Vite for build tooling

## Setup

### Prerequisites
- Node.js 18+
- npm or yarn

### Installation

```bash
cd web-v4-1
npm install
cp .env.example .env
```

### Development

```bash
npm run dev
```

Visit `http://localhost:5173` in your browser.

### Build

```bash
npm run build
npm run preview
```

## Environment Variables

```env
VITE_API_URL=http://localhost:3000
```

## Project Structure

```
src/
├── components/      # Reusable UI components
├── pages/          # Page components
├── api/            # API queries and client
├── stores/         # Zustand state management
├── types/          # TypeScript types
└── index.css       # Global styles with Tailwind
```

## v4.1 Color Palette

- **Accent**: `#E91E76` (Magenta)
- **Background**: `#FFFFFF` (Pure white)
- **Surface Alt**: `#F7F7F8` (Off-white)
- **Success**: `#2D7D46` (Green)
- **Danger**: `#C0392B` (Red)
- **Amber**: `#B8860B` (Pending)
- **Text**: `#1A1A1A` (Near-black)
- **Text Muted**: `#6B6B6B` (Gray)

## API Integration

The dashboard connects to Salone backend APIs:

- `GET /api/v2/auth/me` - User and salon data
- `GET /api/v2/salons/:id/bookings` - Bookings
- `GET /api/v2/salons/:id/stylists` - Staff
- `GET /api/v2/salons/:id/services` - Services
- `GET /api/v2/salons/:id/products` - Inventory
- `GET /api/v2/salons/:id/retention` - Insights
- `GET /api/v2/salons/:id/earnings` - Earnings

Authenticated requests include JWT token from `localStorage.auth_token`.

## Deployment

```bash
npm run build
# Output is in dist/ directory
```

Deploy to Vercel, Netlify, or your preferred host.
