import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: '#1B8A8A',
        'primary-dark': '#0D5C5C',
        'primary-deep': '#083D3D',
        'primary-light': '#E8F4F8',
        'primary-50': '#F0FAFA',
        'primary-100': '#D4EEEE',
        'primary-200': '#A9DEDE',
        accent: '#1B8A8A',
        success: '#10B981',
        'success-light': '#D1FAE5',
        danger: '#EF4444',
        'danger-light': '#FEE2E2',
        warning: '#F59E0B',
        'warning-light': '#FEF3C7',
        info: '#3B82F6',
        'info-light': '#DBEAFE',
      },
      fontFamily: {
        sans: ['var(--font-inter)', 'ui-sans-serif', 'system-ui', 'sans-serif'],
      },
      fontSize: {
        'xs': '0.75rem',
        'sm': '0.875rem',
        'base': '1rem',
        'lg': '1.125rem',
        'xl': '1.25rem',
        '2xl': '1.5rem',
        '3xl': '1.875rem',
      },
      boxShadow: {
        'xs': '0 1px 2px 0 rgba(0, 0, 0, 0.05)',
        'sm': '0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06)',
        'md': '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)',
        'lg': '0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05)',
        'xl': '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)',
        'card': '0 1px 2px rgba(16, 24, 40, 0.04), 0 1px 3px rgba(16, 24, 40, 0.06)',
        'hero': '0 8px 24px -8px rgba(13, 92, 92, 0.45)',
      },
    },
  },
  plugins: [],
}
export default config
