# Salone Web Dashboard

Professional web dashboard for salon management matching the v4.1 mobile app design.

## Features

- 📊 Dashboard with KPI cards and real-time metrics
- 📅 Bookings management and calendar view
- 👥 Staff CRM with commission/salary tracking
- 📈 Insights with earnings analytics
- ✂️ Services catalog management
- 📦 Inventory tracking
- 🌿 Multi-branch support
- 🎨 Exact v4.1 design system (magenta accent, clean white UI)

## Tech Stack

- React 18 + TypeScript
- React Router v6
- TailwindCSS (custom v4.1 theme)
- React Query for data fetching
- Recharts for analytics
- Zustand for state management

## Setup

### Prerequisites
- Node.js 18+
- npm or yarn

### Installation

```bash
# Install dependencies
npm install

# Create .env file
cp .env.example .env

# Update API URL if needed
# VITE_API_URL=http://your-api-url:3000
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
├── components/        # Reusable UI components
├── pages/            # Page components
├── api/              # API queries and client
├── stores/           # Zustand state management
├── types/            # TypeScript types
└── index.css         # Global styles with Tailwind
```

## Color Palette (v4.1 Exact)

- **Accent**: `#E91E76` (Magenta - user-selectable)
- **Background**: `#FFFFFF` (Pure white)
- **Surface Alt**: `#F7F7F8` (Off-white)
- **Success**: `#2D7D46`
- **Danger**: `#C0392B`
- **Amber**: `#B8860B` (Pending/needs action)
- **Text**: `#1A1A1A` (Near-black)
- **Text Muted**: `#6B6B6B` (Gray)

## API Integration

The dashboard connects to your Salone backend APIs:

- `GET /api/v2/auth/me` - User and salon data
- `GET /api/v2/salons/:id/bookings` - Bookings
- `GET /api/v2/salons/:id/stylists` - Staff
- `GET /api/v2/salons/:id/services` - Services
- `GET /api/v2/salons/:id/products` - Inventory
- `GET /api/v2/salons/:id/retention` - Insights/retention data
- `GET /api/v2/salons/:id/earnings` - Earnings analytics

Authenticated requests include JWT token from `localStorage.auth_token`.

## Deployment

```bash
# Build for production
npm run build

# Output is in dist/ directory
# Deploy to Vercel, Netlify, or your preferred host
```

## Development Notes

- Icons use emoji for simplicity (no icon library dependency)
- Tailwind theme extends with v4.1 custom colors in `tailwind.config.js`
- All shadows match v4.1: `0 3px 16px rgba(26, 26, 26, 0.06)`
- Border radius: pills (999px) for buttons, 18px for cards
- Responsive design works on mobile (sidebar collapses, layout adjusts)
