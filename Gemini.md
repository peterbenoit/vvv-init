# GEMINI.md

## Tech Stack

- Framework: Vue 3
- Build Tool: Vite
- Hosting: Vercel

## Constraints

- Do not use Vue Router unless explicitly added
- Do not use external JS libraries unless approved
- Use TailwindCSS for all styling
- Use Composition API, not Options API
- No jQuery, Bootstrap, or legacy CSS frameworks

## File Structure

- Prefer fewer, larger files over many tiny ones
- Use `components/`, `composables/`, and `assets/` folders where needed
- Use `.vue` Single File Components

## UI & UX

- Follow minimalist design
- Keep all interactions accessible (keyboard + screen reader friendly)
- Avoid animations unless specifically requested

## Behavior

- This is a single-page app, not multipage
- All state should be local or in `useX()` composables
- Do not assume backend APIs unless specified

## Tasks Format

When responding to a prompt, first summarize your plan, then write code. If the
task is vague, ask for clarification before generating code.
