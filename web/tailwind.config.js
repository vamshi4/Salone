/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        // Salone teal/green design
        salone: {
          bg: '#F0F7F6',
          surface: '#FFFFFF',
          'surface-alt': '#F5FFFE',
          border: '#E0F0ED',
          ink: '#1A1A1A',
          'ink-muted': '#6B6B6B',
          'ink-faint': '#9E9E9E',
          // Accent (Teal)
          accent: '#00796B',
          'accent-soft': '#B2CFCB',
          'accent-lighter': '#D4E8E6',
          // Semantic
          danger: '#C0392B',
          'danger-soft': '#FEF2F2',
          success: '#2D7D46',
          'success-soft': '#EDF7F0',
          amber: '#B8860B',
          'amber-soft': '#FEF7E0',
          violet: '#6D28D9',
          'violet-soft': '#F1EBFB',
          whatsapp: '#25D366',
        },
      },
      borderRadius: {
        pill: '999px',
        sm: '10px',
        md: '14px',
        lg: '18px',
        xl: '24px',
      },
      spacing: {
        xs: '6px',
        sm: '10px',
        md: '16px',
        lg: '24px',
        xl: '32px',
      },
      boxShadow: {
        card: '0 3px 16px rgba(26, 26, 26, 0.06)',
        'card-hover': '0 8px 24px rgba(26, 26, 26, 0.1)',
      },
      fontFamily: {
        sans: ['Inter', '-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', 'sans-serif'],
      },
      fontWeight: {
        medium: '500',
        semibold: '600',
        bold: '700',
        extrabold: '800',
      },
    },
  },
  plugins: [],
};
