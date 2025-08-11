import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [
    RubyPlugin(), 
    react({
      // React 19 compatible configuration
      jsxRuntime: 'automatic',
      jsxImportSource: 'react'
    })
  ],
  // Production build optimization
  build: {
    rollupOptions: {
      external: []
    },
    // Ensure clean builds
    emptyOutDir: true,
    // Optimize for production
    minify: 'esbuild',
    // Source maps for debugging
    sourcemap: false
  },
  // Optimize dependencies
  optimizeDeps: {
    include: ['react', 'react-dom']
  },
  // ESBuild configuration
  esbuild: {
    jsx: 'automatic'
  }
})


