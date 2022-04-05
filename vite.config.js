import { plugin as elmPlugin } from 'vite-plugin-elm'

const config = {
  build: {
    assetsInlineLimit: 24576
  },
  plugins: [elmPlugin()]
}

export default config
