/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        // Modern professional palette
        salone: {
          bg: '#F8FAFB',
          surface: '#FFFFFF',
          'surface-alt': '#F3F4F6',
          'surface-hover': '#EEEFF3',
          border: '#E5E7EB',
          'border-strong': '#D1D5DB',
          ink: '#111827',
          'ink-secondary': '#4B5563',
          'ink-muted': '#6B7280',
          'ink-faint': '#9CA3AF',
          // Modern blue accent (professional)
          accent: '#0066CC',
          'accent-dark': '#0052A3',
          'accent-light': '#E0EDFF',
          'accent-soft': '#F0F7FF',
          // Semantic colors
          success: '#059669',
          'success-light': '#ECFDF5',
          danger: '#DC2626',
          'danger-light': '#FEF2F2',
          warning: '#D97706',
          'warning-light': '#FFFBEB',
          info: '#0284C7',
          'info-light': '#F0F9FF',
        },
      },
      borderRadius: {
        xs: '4px',
        sm: '6px',
        md: '8px',
        lg: '12px',
        xl: '16px',
      },
      spacing: {
        xs: '4px',
        sm: '8px',
        md: '12px',
        lg: '16px',
        xl: '24px',
        '2xl': '32px',
      },
      boxShadow: {
        xs: '0 1px 2px 0 rgba(0, 0, 0, 0.05)',
        sm: '0 1px 3px 0 rgba(0, 0, 0, 0.08), 0 1px 2px 0 rgba(0, 0, 0, 0.04)',
        md: '0 4px 6px -1px rgba(0, 0, 0, 0.08), 0 2px 4px -1px rgba(0, 0, 0, 0.04)',
        lg: '0 10px 15px -3px rgba(0, 0, 0, 0.08), 0 4px 6px -2px rgba(0, 0, 0, 0.04)',
        xl: '0 20px 25px -5px rgba(0, 0, 0, 0.08), 0 10px 10px -5px rgba(0, 0, 0, 0.04)',
      },
      fontFamily: {
        sans: ['Inter', '-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', 'sans-serif'],
      },
      fontWeight: {
        light: '300',
        normal: '400',
        medium: '500',
        semibold: '600',
        bold: '700',
        extrabold: '800',
      },
      transitionDuration: {
        fast: '150ms',
        base: '200ms',
        slow: '300ms',
      },
    },
  },
  plugins: [],
};
