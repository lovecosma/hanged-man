# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Development (Rails + Vite together)
bin/dev                   # Start Rails + Vite dev server via foreman (loads .env)
bin/rails server          # Start Rails only (requires .env to be loaded separately)

# Database
bin/rails db:migrate
bin/rails db:test:prepare

# Testing (RSpec)
bundle exec rspec                              # All specs
bundle exec rspec spec/models/user_spec.rb     # Single file
bundle exec rspec spec/models/user_spec.rb:12  # Single example by line

# Testing (Vitest — frontend unit tests)
cd app/client && npm test             # Run once
cd app/client && npm run test:watch   # Watch mode

# Code quality
bin/rubocop            # Lint
bin/rubocop -a         # Auto-fix
bin/brakeman --no-pager  # Security scan
```

## Architecture

**Rails 8.0 API-only** (`config.api_only = true`) with an embedded Vite/React frontend at `app/client/`.

In development, `FallbackController` proxies all non-API routes to the Vite dev server (`VITE_DEV_URL`, default `http://localhost:5173`). In production it serves the pre-built `public/index.html`. All API routes must be under `/api` to avoid conflict with the SPA catch-all.

### Database

PostgreSQL. Rails 8 solid gems (SolidCache, SolidQueue, SolidCable) share the same database as app tables via `DATABASE_URL`/`config/database.yml`.

### Infrastructure

Rails 8 solid gems for all persistent infrastructure (no Redis):

- **SolidQueue** — background jobs
- **SolidCache** — Rails cache store
- **SolidCable** — Action Cable backend

### Environment variables

| Variable       | Required   | Notes                                                     |
| -------------- | ---------- | ---------------------------------------------------------- |
| `DATABASE_URL` | Production | Points at the Postgres instance                            |
| `CORS_ORIGIN`  | All        | Single origin; defaults to `http://localhost:5173` in dev  |

Local dev: copy values into `.env` (loaded by foreman via `bin/dev`). The `.env` file is gitignored.

### Testing

RSpec with FactoryBot. Tests hit a real PostgreSQL database — no DB mocking.

### Frontend code style

- Always use the `classnames` library (`cn(...)`) for constructing class strings in React components. Prefer it over template literals or string concatenation for all conditional and composed class names.
- Tailwind CSS v4 via `@tailwindcss/vite`.
- `react-router-dom` for client-side routing.
