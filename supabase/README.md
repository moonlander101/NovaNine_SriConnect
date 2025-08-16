# Sri Connect - Supabase Setup Guide

This guide will help you set up and manage the Supabase backend for the Sri Connect application.

## Prerequisites

- Node.js (v18 or higher)
- Docker Desktop (for local development)
- Supabase CLI
- Git

## Installation

### 1. Install Supabase CLI

```bash
npm install -g supabase
```

### 2. Verify Installation

```bash
supabase --version
```

## Quick Start

### 1. Start Local Supabase

Navigate to the supabase directory and start the local development environment:

```bash
cd supabase
npx supabase start
```

This will:
- Pull and start Docker containers for PostgreSQL, PostgREST, GoTrue, Realtime, etc.
- Apply all migrations from `supabase/migrations/`
- Seed the database if seed files exist
- Start the Supabase Studio on `http://localhost:54323`

### 2. Check Status

```bash
npx supabase status
```

You should see output similar to:
```
API URL: http://127.0.0.1:54321
GraphQL URL: http://127.0.0.1:54321/graphql/v1
DB URL: postgresql://postgres:postgres@127.0.0.1:54322/postgres
Studio URL: http://127.0.0.1:54323
Inbucket URL: http://127.0.0.1:54324
JWT secret: super-secret-jwt-token-with-at-least-32-characters-long
anon key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
service_role key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

## Linking to Remote Project

### 1. Login to Supabase

```bash
npx supabase login
```

### 2. Link to Remote Project

Replace `your-project-ref` with your actual project reference:

```bash
npx supabase link --project-ref your-project-ref
```

### 3. Pull Remote Schema (Optional)

If you want to sync your local schema with the remote:

```bash
npx supabase db pull
```

## Managing Migrations

### 1. Create a New Migration

```bash
npx supabase migration new migration_name
```

This creates a new SQL file in `supabase/migrations/` with a timestamp prefix.

### 2. Apply Migrations to Local Database

```bash
npx supabase db reset
```

Or to apply only new migrations:

```bash
npx supabase migration up
```

### 3. Apply Migrations to Remote Database

```bash
npx supabase db push
```

### 4. Generate Types (TypeScript)

```bash
npx supabase gen types typescript --local > types/supabase.ts
```

## Edge Functions

### 1. Deploy Edge Functions

```bash
npx supabase functions deploy
```

### 2. Deploy Specific Function

```bash
npx supabase functions deploy service-booking
```

### 3. Test Functions Locally

```bash
npx supabase functions serve
```

## Database Management

### 1. Reset Local Database

```bash
npx supabase db reset
```

### 2. Connect to Local Database

```bash
npx supabase db connect
```

### 3. Run SQL Commands

```bash
npx supabase db query "SELECT * FROM app_user LIMIT 5;"
```

## Configuration Files

### Environment Variables

Create a `.env` file in your project root:

```env
# Local Development
SUPABASE_URL=http://127.0.0.1:54321
SUPABASE_ANON_KEY=your-anon-key-from-supabase-status
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key-from-supabase-status

# Production (replace with your values)
# SUPABASE_URL=https://your-project-ref.supabase.co
# SUPABASE_ANON_KEY=your-production-anon-key
# SUPABASE_SERVICE_ROLE_KEY=your-production-service-role-key
```

### Supabase Config

The `config.toml` file contains your project configuration. Key sections:

```toml
[api]
enabled = true
port = 54321

[db]
port = 54322

[studio]
enabled = true
port = 54323
```

## Project Structure

```
supabase/
├── config.toml           # Supabase configuration
├── seed.sql             # Database seed data
├── migrations/          # Database migrations
│   ├── 20250814132608_init.sql
│   └── ...
├── functions/           # Edge Functions
│   ├── service-booking/
│   │   ├── index.ts
│   │   ├── router.ts
│   │   ├── handlers/
│   │   ├── queries/
│   │   └── helpers/
│   └── _shared/
└── schemas/            # RLS policies and additional schemas
    ├── 06_RLS_policies.sql
    ├── 09_Buckets.sql
    └── ...
```

## Common Commands Cheatsheet

| Command | Description |
|---------|-------------|
| `npx supabase start` | Start local development environment |
| `npx supabase stop` | Stop local environment |
| `npx supabase status` | Check status of local environment |
| `npx supabase db reset` | Reset local database and apply all migrations |
| `npx supabase db push` | Push local migrations to remote |
| `npx supabase db pull` | Pull remote schema to local |
| `npx supabase functions deploy` | Deploy all Edge Functions |
| `npx supabase migration new <name>` | Create new migration |
| `npx supabase gen types typescript --local` | Generate TypeScript types |

## Troubleshooting

### 1. Port Already in Use

If you get port conflicts, you can change ports in `config.toml` or stop other services:

```bash
npx supabase stop
docker ps
docker stop <container-id>
```

### 2. Migration Issues

If migrations fail:

```bash
# Reset and try again
npx supabase db reset

# Check migration status
npx supabase migration list
```

### 3. Docker Issues

```bash
# Remove all containers and start fresh
npx supabase stop
docker system prune -f
npx supabase start
```

### 4. Edge Function Deployment Issues

```bash
# Check function logs
npx supabase functions logs service-booking

# Test function locally first
npx supabase functions serve
```

## Development Workflow

1. **Start Development Environment**
   ```bash
   npx supabase start
   ```

2. **Make Schema Changes**
   - Create migration: `npx supabase migration new feature_name`
   - Edit the SQL file in `migrations/`
   - Apply locally: `npx supabase db reset`

3. **Test Changes**
   - Use Supabase Studio: `http://localhost:54323`
   - Run tests or use the API

4. **Deploy to Production**
   ```bash
   npx supabase db push
   npx supabase functions deploy
   ```

## Additional Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase CLI Reference](https://supabase.com/docs/reference/cli)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Edge Functions Guide](https://supabase.com/docs/guides/functions)

## Support

For issues specific to this project, please check:
1. This README
2. Project documentation
3. Supabase official documentation
4. Create an issue in the project repository