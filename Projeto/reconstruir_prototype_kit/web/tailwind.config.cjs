/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: 'class',
  content: ['./src/**/*.{ts,tsx,js,jsx,html}'],
  theme: {
    extend: {
      colors: {
        brand: '#6EE7B7',
        bg: {
          DEFAULT: '#FFFFFF',
          muted: '#F3F4F6',
          dark: '#0B0F0E',
          darkMuted: '#111827',
        },
        text: {
          DEFAULT: '#111827',
          muted: '#6B7280',
          dark: '#F9FAFB',
          darkMuted: '#9CA3AF',
        },
        border: {
          DEFAULT: '#E5E7EB',
          dark: '#1F2937',
        },
        success: '#16A34A',
        warning: '#F59E0B',
        error: '#EF4444',
        info: '#3B82F6',
      },
      borderRadius: {
        sm: '8px',
        md: '12px',
        lg: '16px',
      },
      boxShadow: {
        card: '0 1px 2px rgba(0,0,0,0.06)',
        raised: '0 4px 12px rgba(0,0,0,0.08)',
        cardDark: '0 1px 2px rgba(0,0,0,0.5)',
        raisedDark: '0 6px 20px rgba(0,0,0,0.45)',
      },
      transitionDuration: {
        fast: '180ms',
        base: '220ms',
      },
      transitionTimingFunction: {
        inout: 'cubic-bezier(0.2, 0, 0, 1)',
      },
    },
  },
  plugins: [],
};
