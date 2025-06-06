#!/bin/bash
#===============================================================================
# Vercel + Vite + Vue Setup Script
# Creates a modern Vue 3 project with Vite, Tailwind CSS, and serverless API
#===============================================================================

#-------------------------------------------------------------------------------
# Safety check - prevent running inside the template repository
#-------------------------------------------------------------------------------
if [ -f ".template-root" ]; then
  echo "❌ This script should not be run inside the template repository itself."
  echo "🛑 Aborting to prevent accidental overwrite."
  exit 1
fi

#-------------------------------------------------------------------------------
# Clean directory (optional)
#-------------------------------------------------------------------------------
echo "🧹 Do you want to clean the directory before setup? [Y/n]"
read -r clean_confirm
clean_confirm=${clean_confirm:-Y}
if [[ "$clean_confirm" =~ ^[Yy]$ ]]; then
  echo "⚠️  This will delete everything in the current directory except setup.sh."
  read -p "Are you sure? [Y/n] " confirm
  confirm=${confirm:-Y}
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    bash -c 'shopt -s extglob dotglob && eval rm -rf !\(setup.sh\)'
    echo "✅ Clean complete."
    # Wait a moment to ensure the directory is clean
    sleep 1
  else
    echo "❌ Clean aborted."
  fi
fi

#-------------------------------------------------------------------------------
# Create main project files
#-------------------------------------------------------------------------------
# HTML entry point
cat <<EOF > index.html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
    <title>Vercel + Vite + Vue</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
  </head>
  <body class="bg-gray-100 text-gray-800 min-h-screen flex items-center justify-center">
    <div id="app"></div>
    <script type="module" src="/src/main.js"></script>
  </body>
</html>
EOF

# Vite configuration
cat <<EOF > vite.config.js
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()]
})
EOF

# Package configuration
cat <<EOF > package.json
{
  "name": "vercel-vite-vue-api",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "vercel-dev": "vercel dev"
  },
  "dependencies": {
    "vue": "^3.4.0",
    "axios": "^1.6.8",
    "pinia": "^2.0.0"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^5.0.0",
    "vite": "^5.0.0",
    "vercel": "^32.6.1",
    "eslint": "^8.0.0",
    "eslint-plugin-vue": "^9.0.0",
    "prettier": "^3.0.0",
    "eslint-config-prettier": "^9.0.0",
    "eslint-plugin-prettier": "^5.0.0",
    "vitest": "^0.34.0",
    "@vue/test-utils": "^2.4.1",
    "tailwindcss": "^3.3.0",
    "postcss": "^8.4.0",
    "autoprefixer": "^10.4.0",
    "daisyui": "^3.0.0"
  }
}
EOF

#-------------------------------------------------------------------------------
# Create public assets
#-------------------------------------------------------------------------------
mkdir -p public

# Favicon SVG
cat <<EOF > public/favicon.svg
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" width="256" height="256" viewBox="0 0 256 256" xml:space="preserve">
<g style="stroke: none; stroke-width: 0; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: none; fill-rule: nonzero; opacity: 1;" transform="translate(1.4065934065934016 1.4065934065934016) scale(2.81 2.81)">
	<path d="M 56.739 5.685 c 11.837 -5.303 23.925 -7.582 31.412 -3.836 c 3.745 7.487 1.467 19.575 -3.836 31.412 L 56.739 5.685 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(255,82,73); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round"/>
	<path d="M 73.128 52.003 l -0.313 12.825 c -0.031 1.26 -0.393 2.489 -1.05 3.564 L 61.049 85.919 c -1.525 2.494 -5.119 2.572 -6.751 0.147 L 45.107 72.41" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(255,82,73); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round"/>
	<polygon points="17.59,44.89 15.23,56.24 24.5,65.5 33.76,74.77 45.11,72.41 " style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(255,82,73); fill-rule: nonzero; opacity: 1;" transform="  matrix(1 0 0 1 0 0) "/>
	<path d="M 37.967 16.843 l -12.825 0.313 c -1.26 0.031 -2.489 0.393 -3.564 1.05 L 4.052 28.922 c -2.494 1.525 -2.572 5.119 -0.147 6.751 l 13.656 9.191" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(255,82,73); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round"/>
	<path d="M 45.107 72.41 L 17.59 44.893 c 0.231 -0.955 0.511 -1.914 0.875 -2.875 c 2.509 -6.627 6.739 -13.243 12.558 -19.061 C 37.703 16.276 47.141 9.991 56.743 5.69 L 84.31 33.257 c -4.301 9.603 -10.587 19.04 -17.267 25.721 c -5.818 5.818 -12.435 10.049 -19.061 12.558 C 47.021 71.899 46.062 72.179 45.107 72.41 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(249,249,249); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round"/>
	<circle cx="53.924" cy="36.074" r="11.204" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(123,216,232); fill-rule: nonzero; opacity: 1;" transform="  matrix(1 0 0 1 0 0) "/>
	<path d="M 2 90 c -0.512 0 -1.024 -0.195 -1.414 -0.586 c -0.781 -0.781 -0.781 -2.047 0 -2.828 l 17.709 -17.709 c 0.78 -0.781 2.048 -0.781 2.828 0 c 0.781 0.781 0.781 2.047 0 2.828 L 3.414 89.414 C 3.024 89.805 2.512 90 2 90 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(255,221,120); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round"/>
	<path d="M 2.84 77.48 c -0.512 0 -1.023 -0.195 -1.414 -0.586 c -0.781 -0.781 -0.781 -2.047 0 -2.828 l 11.03 -11.029 c 0.78 -0.781 2.047 -0.781 2.828 0 c 0.781 0.781 0.781 2.047 0 2.828 L 4.254 76.895 C 3.864 77.285 3.352 77.48 2.84 77.48 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(255,221,120); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round"/>
	<path d="M 14.52 89.16 c -0.512 0 -1.024 -0.195 -1.414 -0.586 c -0.781 -0.781 -0.781 -2.047 0 -2.828 l 11.029 -11.029 c 0.78 -0.781 2.048 -0.781 2.828 0 c 0.781 0.781 0.781 2.047 0 2.828 L 15.934 88.574 C 15.543 88.965 15.031 89.16 14.52 89.16 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(255,221,120); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round"/>
</g>
</svg>
EOF

#-------------------------------------------------------------------------------
# Create source files
#-------------------------------------------------------------------------------
mkdir -p src

# Main JavaScript entry point
cat <<EOF > src/main.js
import { createApp } from 'vue'
import App from './App.vue'
import './style.css'

createApp(App).mount('#app')
EOF

# Tailwind CSS configuration
cat <<EOF > src/style.css
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

# Vue application component
cat <<EOF > src/App.vue
<template>
  <div class="text-center space-y-6">
    <div>
      <img src="/favicon.svg" alt="Logo" class="w-24 h-24 mx-auto mb-4">
      <h1 class="text-4xl font-bold text-indigo-600">Vercel + Vite + Vue</h1>
      <p class="text-lg text-gray-600">A streamlined Bash script to scaffold a modern Vue 3 project with Vite, Tailwind CSS, serverless API endpoints, and a complete development setup. This template creates a production-ready project structure that works seamlessly in both local development and Vercel deployments.</p>
    </div>
    <div class="space-y-4">
      <button
        @click="loadMessage"
        class="px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700 transition"
      >
        Call API
      </button>
      <p v-if="message" class="text-gray-700">{{ message }}</p>
    </div>
    <div class="space-y-4">
      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" class="inline-block mr-1 text-gray-800"><path fill="currentColor" d="M12 2A10 10 0 0 0 2 12c0 4.42 2.87 8.17 6.84 9.5c.5.08.66-.23.66-.5v-1.69c-2.77.6-3.36-1.34-3.36-1.34c-.46-1.16-1.11-1.47-1.11-1.47c-.91-.62.07-.6.07-.6c1 .07 1.53 1.03 1.53 1.03c.87 1.52 2.34 1.07 2.91.83c.09-.65.35-1.09.63-1.34c-2.22-.25-4.55-1.11-4.55-4.92c0-1.11.38-2 1.03-2.71c-.1-.25-.45-1.29.1-2.64c0 0 .84-.27 2.75 1.02c.79-.22 1.65-.33 2.5-.33s1.71.11 2.5.33c1.91-1.29 2.75-1.02 2.75-1.02c.55 1.35.2 2.39.1 2.64c.65.71 1.03 1.6 1.03 2.71c0 3.82-2.34 4.66-4.57 4.91c.36.31.69.92.69 1.85V21c0 .27.16.59.67.5C19.14 20.16 22 16.42 22 12A10 10 0 0 0 12 2"/></svg>
      <a href="https://github.com/peterbenoit/vvv-init" target="_blank" class="text-indigo-600 hover:underline text-sm">
        GitHub
      </a>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const message = ref('')
const apiBase = import.meta.env.VITE_API_BASE

onMounted(() => {
  console.log('Frontend var:', import.meta.env.VITE_PUBLIC_MESSAGE)
})

async function loadMessage() {
  const res = await fetch(\`\${apiBase}/hello\`)
  const data = await res.json()
  message.value = data.message
}
</script>
EOF

#-------------------------------------------------------------------------------
# Create API endpoints
#-------------------------------------------------------------------------------
mkdir -p api

# Example API endpoint
cat <<EOF > api/hello.js
import axios from 'axios'

export default async function handler(req, res) {
  try {
    console.log('Backend var:', process.env.PRIVATE_BACKEND_SECRET)
    const response = await axios.get('https://jsonplaceholder.typicode.com/posts')
    const posts = response.data.slice(0, 10)
    const random = posts[Math.floor(Math.random() * posts.length)]
    res.writeHead(200, { 'Content-Type': 'application/json' })
    res.end(JSON.stringify({
      message: random.title,
      backendSecret: process.env.PRIVATE_BACKEND_SECRET
    }))
  } catch (error) {
    res.writeHead(500, { 'Content-Type': 'application/json' })
    res.end(JSON.stringify({ error: 'Failed to fetch data' }))
  }
}
EOF

#-------------------------------------------------------------------------------
# Create configuration files
#-------------------------------------------------------------------------------
# Vercel configuration
cat <<EOF > vercel.json
{
  "rewrites": [
    { "source": "/api/(.*)", "destination": "/api/\$1" }
  ]
}
EOF

# Git ignore
cat <<EOF > .gitignore
node_modules/
dist/
.vscode/
.env
.vercel/
EOF

# Environment variables
cat <<EOF > .env
VITE_PUBLIC_MESSAGE=Hello from the frontend
VITE_API_BASE=/api
PRIVATE_BACKEND_SECRET=shhh this is secret
EOF

#-------------------------------------------------------------------------------
# Install dependencies
#-------------------------------------------------------------------------------
echo "📦 Installing dependencies..."

# Install runtime dependencies
npm install vue axios pinia daisyui

# Install development dependencies
npm install -D @vitejs/plugin-vue vite vercel \
  eslint eslint-plugin-vue prettier eslint-config-prettier eslint-plugin-prettier \
  vitest @vue/test-utils \
  tailwindcss postcss autoprefixer

# Initialize Tailwind CSS
npx tailwindcss init -p

# Create Tailwind configuration
cat <<EOF > tailwind.config.js
module.exports = {
  content: ['./index.html', './src/**/*.{vue,js,ts}'],
  theme: {
    extend: {},
  },
  plugins: [require('daisyui')],
}
EOF

#-------------------------------------------------------------------------------
# Optional: Add Vue Router
#-------------------------------------------------------------------------------
echo "🧭 Do you want to include vue-router for multipage support? [y/N]"
read -r router_confirm
router_confirm=${router_confirm:-N}
if [[ "$router_confirm" =~ ^[Yy]$ ]]; then
  npm install vue-router
  echo "✅ vue-router installed."

  # Create router configuration
  cat <<EOR > src/router.js
import { createRouter, createWebHistory } from 'vue-router'
import Home from './pages/Home.vue'
import About from './pages/About.vue'

const routes = [
  { path: '/', component: Home },
  { path: '/about', component: About }
]

export default createRouter({
  history: createWebHistory(),
  routes
})
EOR

  # Create page components
  mkdir -p src/pages

  # Home page
  cat <<EOH > src/pages/Home.vue
<template>
  <div class="text-center space-y-4">
    <div>
      <img src="/favicon.svg" alt="Logo" class="w-24 h-24 mx-auto mb-4">
      <h1 class="text-4xl font-bold text-indigo-600">Vercel + Vite + Vue</h1>
      <p class="text-lg text-gray-600">A streamlined Bash script to scaffold a modern Vue 3 project with Vite, Tailwind CSS, serverless API endpoints, and a complete development setup. This template creates a production-ready project structure that works seamlessly in both local development and Vercel deployments.</p>
    </div>
    <button
      @click="loadMessage"
      class="px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700 transition"
    >
      Call API
    </button>
    <p v-if="message" class="text-gray-700">{{ message }}</p>
  </div>
  <div class="space-y-4">
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" class="inline-block mr-1 text-gray-800"><path fill="currentColor" d="M12 2A10 10 0 0 0 2 12c0 4.42 2.87 8.17 6.84 9.5c.5.08.66-.23.66-.5v-1.69c-2.77.6-3.36-1.34-3.36-1.34c-.46-1.16-1.11-1.47-1.11-1.47c-.91-.62.07-.6.07-.6c1 .07 1.53 1.03 1.53 1.03c.87 1.52 2.34 1.07 2.91.83c.09-.65.35-1.09.63-1.34c-2.22-.25-4.55-1.11-4.55-4.92c0-1.11.38-2 1.03-2.71c-.1-.25-.45-1.29.1-2.64c0 0 .84-.27 2.75 1.02c.79-.22 1.65-.33 2.5-.33s1.71.11 2.5.33c1.91-1.29 2.75-1.02 2.75-1.02c.55 1.35.2 2.39.1 2.64c.65.71 1.03 1.6 1.03 2.71c0 3.82-2.34 4.66-4.57 4.91c.36.31.69.92.69 1.85V21c0 .27.16.59.67.5C19.14 20.16 22 16.42 22 12A10 10 0 0 0 12 2"/></svg>
    <a href="https://github.com/peterbenoit/vvv-init" target="_blank" class="text-indigo-600 hover:underline text-sm">
      GitHub
    </a>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const apiBase = import.meta.env.VITE_API_BASE
const message = ref('')

onMounted(() => {
  console.log('Frontend var:', import.meta.env.VITE_PUBLIC_MESSAGE)
})

async function loadMessage() {
  const res = await fetch(\`\${apiBase}/hello\`)
  const data = await res.json()
  message.value = data.message
}
</script>
EOH

  # About page
  cat <<EOA > src/pages/About.vue
<template>
  <div class="text-center space-y-4">
    <h2 class="text-2xl font-bold text-blue-600">About Page</h2>
    <p>This is the about page.</p>
  </div>
</template>
EOA

  # Update main.js to include router
  sed -i '' 's|createApp(App).mount|import router from "./router"\
createApp(App).use(router).mount|' src/main.js

  # Update App.vue to use router
  cat <<EOAPP > src/App.vue
<template>
  <div class="space-y-4 text-center">
    <nav class="space-x-4">
      <router-link to="/" class="text-indigo-600 hover:underline">Home</router-link>
      <router-link to="/about" class="text-indigo-600 hover:underline">About</router-link>
    </nav>
    <router-view />
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
onMounted(() => {
  console.log('Frontend var:', import.meta.env.VITE_PUBLIC_MESSAGE)
})
</script>
EOAPP
fi

#-------------------------------------------------------------------------------
# Optional: Initialize Git repository
#-------------------------------------------------------------------------------
echo "🔧 Do you want to initialize a Git repository in this project? [Y/n]"
read -r git_confirm
git_confirm=${git_confirm:-Y}
if [[ "$git_confirm" =~ ^[Yy]$ ]]; then
  git init
  git add .
  git commit -m "Initial project setup"
  echo "✅ Git repository initialized."

  # Optional: Set remote Git origin
  echo "🌐 Do you want to set a remote Git origin? [y/N]"
  read -r origin_confirm
  origin_confirm=${origin_confirm:-N}
  if [[ "$origin_confirm" =~ ^[Yy]$ ]]; then
    read -p "Enter the remote repository URL: " remote_url
    git remote add origin "$remote_url"
    echo "🔗 Remote origin set to $remote_url"
  fi
fi

#-------------------------------------------------------------------------------
# Set up Husky for Git hooks
#-------------------------------------------------------------------------------
echo "🐶 Setting up Husky pre-commit hook..."
yes | npx husky-init
npm install
npx husky set .husky/pre-commit "npx prettier --check ."
echo "✅ Husky pre-commit hook created (Prettier check)"

#-------------------------------------------------------------------------------
# Finish and start dev server
#-------------------------------------------------------------------------------
echo "✅ Project ready."
echo "🚀 Do you want to run the dev server now? [Y/n]"
read -r dev_confirm
dev_confirm=${dev_confirm:-Y}
if [[ "$dev_confirm" =~ ^[Yy]$ ]]; then
  npx vercel dev
fi

echo "🎉 Setup complete! Your Vercel + Vite + Vue project is ready."
echo "📖 Check the README for more information on how to use this project."
