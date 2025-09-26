const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    "./app/views/**/*",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*",
    "./app/assets/stylesheets/**/*.css"
  ],
  theme: {
    extend: {
      colors: {
        primary:   { DEFAULT: "#1E3A8A", light: "#3B82F6" },
        secondary: { DEFAULT: "#10B981", dark: "#059669" },
        neutral:   { light: "#F3F4F6",  dark: "#374151" },
        accent:    { DEFAULT: "#F97316", dark: "#EA580C" }
      }
    }
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
