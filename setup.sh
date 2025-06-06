#!/bin/bash

# Parse optional flags
WITH_ROUTER=false
CLEAN_FIRST=false
for arg in "$@"; do
  if [ "$arg" == "--with-router" ]; then
    WITH_ROUTER=true
  elif [ "$arg" == "--clean" ]; then
    CLEAN_FIRST=true
  fi
done

# Clean current directory if requested
if $CLEAN_FIRST; then
  echo "⚠️  This will delete everything in the current directory except setup.sh."
  read -p "Are you sure? [Y/n] " confirm
  confirm=${confirm:-Y}
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    # bash -c 'shopt -s extglob && eval rm -rf !\(setup.sh\)'
	bash -c 'shopt -s extglob dotglob && eval rm -rf !\(setup.sh\)'
    echo "🧹 Clean complete. Press Enter to continue..."
    read
  else
    echo "❌ Clean aborted."
  fi
fi

# index.html
cat <<EOF > index.html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Vercel + Vite + Vue</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
  </head>
  <body class="bg-gray-100 text-gray-800 min-h-screen flex items-center justify-center">
    <div class="text-center space-y-4">
      <h1 class="text-4xl font-bold text-indigo-600">Vercel + Vite + Vue</h1>
      <p class="text-lg">A minimal fullstack setup with serverless API and Tailwind CSS.</p>
      <div id="app"></div>
    </div>
    <script type="module" src="/src/main.js"></script>
  </body>
</html>
EOF

# vite.config.js
cat <<EOF > vite.config.js
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()]
})
EOF

# package.json
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

# src/main.js
mkdir -p src
cat <<EOF > src/main.js
import { createApp } from 'vue'
import App from './App.vue'
import './style.css'

createApp(App).mount('#app')
EOF

# src/style.css
cat <<EOF > src/style.css
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

# src/App.vue
cat <<EOF > src/App.vue
<template>
	<div class="space-y-4">
		<button
		@click="loadMessage"
		class="px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700 transition"
		>
		Call API
		</button>
		<p v-if="message" class="text-gray-700">{{ message }}</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const message = ref('')
const apiBase = import.meta.env.DEV ? 'http://localhost:3000/api' : '/api'

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

# api/hello.js
mkdir -p api
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

# vercel.json
cat <<EOF > vercel.json
{
  "rewrites": [
    { "source": "/api/(.*)", "destination": "/api/\$1" }
  ]
}
EOF

# .gitignore
cat <<EOF > .gitignore
node_modules/
dist/
.vscode/
.env
.vercel/
EOF

# .env
cat <<EOF > .env
VITE_PUBLIC_MESSAGE=Hello from the frontend
PRIVATE_BACKEND_SECRET=shhh this is secret
EOF


# Install all dependencies
npm install vue axios pinia daisyui
npm install -D @vitejs/plugin-vue vite vercel \
  eslint eslint-plugin-vue prettier eslint-config-prettier eslint-plugin-prettier \
  vitest @vue/test-utils \
  tailwindcss postcss autoprefixer
npx tailwindcss init -p

cat <<EOF > tailwind.config.js
module.exports = {
  content: ['./index.html', './src/**/*.{vue,js,ts}'],
  theme: {
    extend: {},
  },
  plugins: [require('daisyui')],
}
EOF

echo "✅ Project ready — launching with Vercel dev server..."
npx vercel dev
