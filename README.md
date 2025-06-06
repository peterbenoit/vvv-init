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

## Usage

```bash
chmod +x setup.sh
./setup.sh
```

### Options

- `--clean` — Deletes everything in the current directory except `setup.sh`, with confirmation
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
