/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./hugo_stats.json'],
  theme: {
    extend: {
      fontFamily: {
        'sans': "Avenir, Montserrat, Corbel, 'URW Gothic', source-sans-pro, sans-serif",
        'serif': "Charter, 'Bitstream Charter', 'Sitka Text', Cambria, serif",
        'mono': "ui-monospace, 'Cascadia Code', 'Source Code Pro', Menlo, Consolas, 'DejaVu Sans Mono', monospace"
      }
    },
  },
  plugins: [
    require('@tailwindcss/typography')
  ],
}

