# Salone Web Dashboard - Quick Start Guide

## 🚀 Installation & Running

### Step 1: Install Dependencies
```bash
cd web
npm install
```

### Step 2: Setup Environment
```bash
# Copy the example env file
cp .env.example .env

# If your backend is NOT on localhost:3000, update .env:
# VITE_API_URL=http://your-ip:3000
```

### Step 3: Run Development Server
```bash
npm run dev
```

Visit **http://localhost:5173** in your browser.

---

## 📁 Project Structure

```
web/
├── src/
│   ├── components/          # Reusable UI components
│   │   ├── Sidebar.tsx
│   │   ├── TopBar.tsx
│   │   ├── BranchSwitcher.tsx
│   │   ├── StatCard.tsx
│   │   ├── Card.tsx
│   │   └── Badge.tsx
│   ├── pages/              # Page components
│   │   ├── Home.tsx
│   │   ├── Bookings.tsx
│   │   ├── Staff.tsx
│   │   ├── Insights.tsx
│   │   ├── Services.tsx
│   │   ├── Inventory.tsx
│   │   ├── Account.tsx
│   │   └── NotFound.tsx
│   ├── api/                # API integration
│   │   ├── client.ts       # Axios instance with auth
│   │   └── queries.ts      # React Query hooks
│   ├── stores/             # State management
│   │   └── appStore.ts     # Zustand store
│   ├── types/              # TypeScript types
│   │   └── index.ts
│   ├── App.tsx             # Main router
│   ├── index.tsx           # Entry point
│   └── index.css           # Tailwind + global styles
├── index.html              # HTML template
├── package.json
├── tsconfig.json
├── tailwind.config.js
├── vite.config.ts
└── README.md
```

---

## 🎨 Design System (v4.1 Exact Match)

### Colors
- **Accent**: `#E91E76` (Magenta) - Primary action color
- **Background**: `#FFFFFF` (Pure white)
- **Surface**: `#FFFFFF` (Cards/containers)
- **Surface Alt**: `#F7F7F8` (Off-white fills)
- **Border**: `#ECECEE` (Light gray borders)
- **Text**: `#1A1A1A` (Near-black primary text)
- **Text Muted**: `#6B6B6B` (Gray secondary text)
- **Text Faint**: `#9E9E9E` (Light gray tertiary text)

### Semantic Colors
- **Success**: `#2D7D46` (Green)
- **Danger**: `#C0392B` (Red)
- **Amber**: `#B8860B` (Gold - for pending/needs action)
- **Violet**: `#6D28D9` (Purple)

### Typography
- **Font**: Inter (sans-serif, no serif pairing)
- **Font Weights**: 500, 600, 700, 800 (medium to extra-bold)
- **Sizes**: Responsive, from 12px to 28px

### Components
- **Buttons**: Pill-shaped (rounded 999px), filled or outlined
- **Cards**: No borders, white surfaces with subtle shadow
- **Inputs**: Pill-shaped, light gray background
- **Shadows**: `0 3px 16px rgba(26, 26, 26, 0.06)` (soft, subtle)
- **Border Radius**: 18px for cards, 10px for components, 999px for pills

---

## 🔌 API Endpoints Connected

The dashboard connects to these backend endpoints:

### Auth
- `GET /api/v2/auth/me` - Get current user and salons

### Salons
- `GET /api/v2/salons` - List all salons
- `GET /api/v2/salons/:id` - Get salon details
- `PATCH /api/v2/salons/:id` - Update salon
- `POST /api/v2/salons` - Create new salon

### Bookings
- `GET /api/v2/salons/:id/bookings?date=YYYY-MM-DD` - Get bookings
- `POST /api/v2/salons/:id/bookings` - Create booking
- `PATCH /api/v2/salons/:id/bookings/:id` - Update booking

### Staff
- `GET /api/v2/salons/:id/stylists` - List staff
- `POST /api/v2/salons/:id/stylists` - Add staff
- `PATCH /api/v2/salons/:id/stylists/:id` - Update staff

### Services
- `GET /api/v2/salons/:id/services` - List services
- `POST /api/v2/salons/:id/services` - Create service
- `PATCH /api/v2/salons/:id/services/:id` - Update service

### Products
- `GET /api/v2/salons/:id/products` - List inventory
- `POST /api/v2/salons/:id/products` - Add product

### Analytics
- `GET /api/v2/salons/:id/retention` - Retention insights
- `GET /api/v2/salons/:id/earnings` - Earnings data

---

## 🔐 Authentication

The dashboard uses **JWT token** from localStorage:

```typescript
// Token is automatically added to all requests
localStorage.setItem('auth_token', 'your_jwt_token');

// API client auto-handles 401 and redirects to login
```

---

## 📱 Features Implemented

### ✅ Home Dashboard
- KPI stat cards (Revenue, Bookings, Staff, Rating)
- Today's bookings table with status badges
- Real-time data from backend

### ✅ Bookings
- Date filter
- List view of all bookings
- Status badges (Pending, Confirmed, Completed, Cancelled)
- Quick actions

### ✅ Staff
- Search and filter
- Active/Inactive status
- Pay type display (Commission/Salary/Both)
- Services per staff member
- Add staff button

### ✅ Insights
- Total revenue, bookings, rating cards
- Earnings by service (bar chart)
- Earnings by staff (bar chart)
- Retention rate
- Real charts with Recharts library

### ✅ Services
- Grouped by category
- Search and filter
- Price and duration display
- Add service button

### ✅ Inventory
- Product listing
- Low stock alerts
- Cost tracking
- Category organization
- Add product button

### ✅ Account
- User profile info
- Account type display
- Change password option
- Security settings

### ✅ Multi-Branch
- Branch switcher dropdown
- Today's stats per branch
- Seamless switching between salons

---

## 🛠️ Development Commands

```bash
# Install dependencies
npm install

# Start dev server (http://localhost:5173)
npm run dev

# Type check
npm run type-check

# Build for production
npm run build

# Preview production build locally
npm run preview
```

---

## 🚀 Deployment

### Vercel (Recommended)
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel
```

### Netlify
```bash
# Install Netlify CLI
npm i -g netlify-cli

# Build and deploy
npm run build
netlify deploy --prod --dir=dist
```

### Docker
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
EXPOSE 3000
CMD ["npm", "run", "preview"]
```

---

## ✨ Customization

### Change Accent Color
Edit `tailwind.config.js`:
```js
colors: {
  salone: {
    accent: '#NEW_COLOR', // Change from #E91E76
    // ...
  }
}
```

### Add New Page
1. Create component in `src/pages/NewPage.tsx`
2. Add route in `src/App.tsx`
3. Add sidebar nav item in `src/components/Sidebar.tsx`

### Modify API Endpoints
Edit `src/api/queries.ts` to add/update API calls.

---

## 🐛 Troubleshooting

### Port 5173 already in use
```bash
npm run dev -- --port 5174
```

### API connection issues
1. Check `.env` file has correct `VITE_API_URL`
2. Ensure backend is running on that URL
3. Check browser console for errors
4. Verify CORS is enabled on backend

### Build errors
```bash
# Clear node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
npm run build
```

---

## 📞 Support

For issues or questions, check:
- Backend API documentation
- v4.1 mobile app for feature reference
- React Query docs for data fetching patterns
- Tailwind CSS docs for styling

---

## 📄 License

Same as Salone project
