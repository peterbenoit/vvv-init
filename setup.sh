#!/bin/bash

if [ -f ".template-root" ]; then
  echo "❌ This script should not be run inside the template repository itself."
  echo "🛑 Aborting to prevent accidental overwrite."
  exit 1
fi


# Prompt to optionally clean the directory before setup
echo "🧹 Do you want to clean the directory before setup? [Y/n]"
read -r clean_confirm
clean_confirm=${clean_confirm:-Y}
if [[ "$clean_confirm" =~ ^[Yy]$ ]]; then
  echo "⚠️  This will delete everything in the current directory except setup.sh."
  read -p "Are you sure? [Y/n] " confirm
  confirm=${confirm:-Y}
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
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
    <div id="app"></div>
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
VITE_API_BASE=/api
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

# Prompt to optionally add Vue Router
echo "🧭 Do you want to include vue-router for multipage support? [y/N]"
read -r router_confirm
router_confirm=${router_confirm:-N}
if [[ "$router_confirm" =~ ^[Yy]$ ]]; then
  npm install vue-router
  echo "✅ vue-router installed."

  # 1. Create src/router.js
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

  # 2. Create src/pages/Home.vue and About.vue
  mkdir -p src/pages
  cat <<EOH > src/pages/Home.vue
<template>
  <div class="text-center space-y-4">
    <h2 class="text-2xl font-bold text-green-600">Home Page</h2>
    <p>Welcome to the homepage!</p>
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

  cat <<EOA > src/pages/About.vue
<template>
  <div class="text-center space-y-4">
    <h2 class="text-2xl font-bold text-blue-600">About Page</h2>
    <p>This is the about page.</p>
  </div>
</template>
EOA

  # 3. Update src/main.js to inject router
  sed -i '' 's|createApp(App).mount|import router from "./router"\
createApp(App).use(router).mount|' src/main.js

  # 4. Update src/App.vue with router layout
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

# Prompt to optionally initialize a Git repository
echo "🔧 Do you want to initialize a Git repository in this project? [Y/n]"
read -r git_confirm
git_confirm=${git_confirm:-Y}
if [[ "$git_confirm" =~ ^[Yy]$ ]]; then
  git init
  git add .
  git commit -m "Initial project setup"
  echo "✅ Git repository initialized."

  # Prompt to set a remote Git origin
  echo "🌐 Do you want to set a remote Git origin? [y/N]"
  read -r origin_confirm
  origin_confirm=${origin_confirm:-N}
  if [[ "$origin_confirm" =~ ^[Yy]$ ]]; then
    read -p "Enter the remote repository URL: " remote_url
    git remote add origin "$remote_url"
    echo "🔗 Remote origin set to $remote_url"
  fi
fi

# Husky installation and pre-commit hook for Prettier
echo "🐶 Setting up Husky pre-commit hook..."
yes | npx husky-init
npm install
npx husky set .husky/pre-commit "npx prettier --check ."
echo "✅ Husky pre-commit hook created (Prettier check)"

echo "✅ Project ready."
echo "🚀 Do you want to run the dev server now? [Y/n]"
read -r dev_confirm
dev_confirm=${dev_confirm:-Y}
if [[ "$dev_confirm" =~ ^[Yy]$ ]]; then
  npx vercel dev
fi

echo "🎉 Setup complete! Your Vercel + Vite + Vue project is ready."
echo "📖 Check the README for more information on how to use this project."
