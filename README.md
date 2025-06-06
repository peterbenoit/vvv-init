# Vercel + Vite + Vue Setup

A fast-start Bash script to scaffold a modern Vue 3 project with Vite, Tailwind CSS, Pinia, ESLint, Prettier, and Vercel-compatible serverless API routing. Designed to work seamlessly on both local development and Vercel deployments.

## Features

- Vue 3 + Vite frontend
- Tailwind CSS + DaisyUI
- Pinia state management
- ESLint + Prettier
- Serverless API via `/api/` endpoints
- `.env` support for frontend (`VITE_`) and backend variables
- Fully compatible with Vercel CLI and production deployment
- Optional Git initialization and remote origin setup
- Husky pre-commit hook with Prettier check

## Usage

```bash
chmod +x setup.sh
./setup.sh
```

You’ll be prompted to:

- Clean the current directory (optional)
- Initialize a Git repository (optional)
- Set a remote Git origin (optional)
- Install Husky with a Prettier pre-commit hook
- Launch the dev server immediately

### Optional Flags

- `--with-router` — Adds `vue-router` to the project

## Environment Variables

- `VITE_PUBLIC_MESSAGE` — accessible from frontend
- `PRIVATE_BACKEND_SECRET` — accessible from backend serverless functions

## Development

Run locally in full mode with:

```bash
npm run vercel-dev
```

This simulates Vercel’s environment, including serverless APIs.

## License

MIT
