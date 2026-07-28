/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: '#1B8A8A',
        'primary-dark': '#0D5C5C',
        'primary-light': '#E8F4F8',
        accent: '#1B8A8A',
        success: '#2D7D46',
        danger: '#D32F2F',
        warning: '#F9A825',
        'text-primary': '#1A1A1A',
        'text-muted': '#6B6B6B',
      },
      backgroundColor: {
        'sidebar': '#E8F4F8',
        'main': '#F5F5F5',
      },
      borderRadius: {
        pill: '999px',
        card: '8px',
      },
    },
  },
  plugins: [],
}
