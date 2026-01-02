# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Project Overview

This is a **Rails boilerplate** project using Docker for containerized development. The project is designed to quickly bootstrap new Rails applications with a standardized setup.

**Key Technologies:**
- Ruby (version configurable in `.env.development`)
- Rails (version configurable in `.env.development`)
- PostgreSQL (version configurable in `.env.development`)
- Docker & Docker Compose
- Tailwind CSS
- Import maps

---

## Common Commands

All commands should be run from the repository root.

### Initial Setup (First Time Only)

```bash
# Create a new Rails application
make init

# Start containers
make up
```

### Development Workflow

```bash
# Start all containers
make up

# Access the app container shell
make bash

# View available make commands
make help
```

### Inside the Container

Once inside the container (`make bash`), you can run:

```bash
# Run Rails console
rails console

# Run database migrations
rails db:migrate

# Run database setup
rails db:setup

# Generate a new model/controller/etc
rails generate model User name:string email:string

# Start Rails server (if not running via bin/dev)
rails server
```

### Docker Commands

```bash
# View running containers
docker compose --env-file .env.development ps

# View logs
docker compose --env-file .env.development logs app
docker compose --env-file .env.development logs db

# Stop containers
docker compose --env-file .env.development down

# Rebuild containers (after changing Dockerfile or dependencies)
docker compose --env-file .env.development build --no-cache

# Clean all Docker resources (WARNING: affects ALL Docker projects)
make clean
```

---

## Architecture

### Docker Setup

The project uses a **multi-container Docker setup**:

1. **app service** (`Dockerfile.app`):
   - Ruby/Rails development environment
   - Mounts current directory to `/app` in container
   - Uses `bundle_cache` volume for gem persistence
   - Runs `bin/dev` by default (starts Rails server and builds assets)
   - Accessible at `http://localhost:3000`

2. **db service**:
   - PostgreSQL database
   - Data persisted in `postgres_data` volume
   - Accessible at `localhost:5432`
   - Health check ensures DB is ready before app starts

### Configuration

#### Environment Variables

**ファイル構成:**
- `.env.development`: 開発環境用の設定（リポジトリにコミット、サンプル値含む）
- `.env.production`: compose.production.yaml想定の本番環境用設定（リポジトリにコミット、サンプル値含む）

**設計方針:**
- `.env` ファイルは使用しない
- `--env-file` オプションで環境ファイルを明示的に指定
- 開発環境: `docker compose --env-file .env.development`
- 本番環境: `docker compose -f compose.production.yaml --env-file .env.production`

**メリット:**
- 環境ファイルのコピー不要
- 使用する環境が明示的
- `.gitignore` の設定不要
- セキュリティ向上（間違って機密情報をコミットするリスク低減）

**環境変数一覧:**
- `RUBY_VERSION`: Ruby version (default: 3.3.6)
- `RAILS_VERSION`: Rails version (default: 8.0.4)
- `POSTGRES_VERSION`: PostgreSQL version (default: 16-bookworm)
- `APP_NAME`: Application name
- `POSTGRES_HOST`, `POSTGRES_PORT`, `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB`: Database credentials
- `DATABASE_URL`: PostgreSQL connection URL (auto-generated)

**本番環境用追加環境変数:**
- `SECRET_KEY_BASE`: Rails secret key
- `RAILS_ENV=production`
- `RAILS_LOG_TO_STDOUT=true`
- `RAILS_SERVE_STATIC_FILES=true`

### Project Structure

```
.
├── .env.development     # Development environment variables (committed)
├── .env.production      # Production environment variables template (committed)
├── compose.yaml         # Docker Compose configuration for development
├── Dockerfile.app       # App container definition (multi-stage)
├── Makefile            # Development shortcuts
├── CONTRIBUTING.md     # Development guidelines and workflow
└── CLAUDE.md           # This file
```

**Note**: After running `make init`, a full Rails application structure will be created in the current directory.

---

## Development Guidelines

**IMPORTANT**: Always follow [CONTRIBUTING.md](CONTRIBUTING.md) for:
- Git workflow and branch naming
- Commit message format (Conventional Commits)
- PR creation process
- Security guidelines
- Code review standards

### Key Workflow Principles

1. **Always create a branch before working**
   - Never commit directly to `main`
   - Branch naming: `<type>/<issue-number>-<description>`
   - Example: `feature/12-user-authentication`

2. **Follow Conventional Commits**
   - Format: `<type>(<scope>): <subject> (issue#<number>)`
   - Example: `feat(auth): add login functionality (issue#12)`

3. **Use Squash and Merge**
   - Default merge strategy for this project
   - Keeps main branch history clean

4. **Never add AI-generated messages**
   - Don't add "Generated with Claude Code" or similar messages
   - Don't add "Co-Authored-By: Claude" to commits or PRs
   - See CONTRIBUTING.md for details

---

## Working with Claude Code

### Effective Prompts

**Good:**
```
Implement issue #12 following CONTRIBUTING.md.
Create a feature branch, implement the User model with email validation,
write RSpec tests, commit, and create a PR.
```

**Bad:**
```
Add a user model
```

### Always Reference CONTRIBUTING.md

When asking Claude to perform development tasks, explicitly mention:
```
Follow CONTRIBUTING.md for branch naming, commit messages, and PR creation.
```

### Security Checks

Always verify security requirements from CONTRIBUTING.md:
- SQL injection prevention (use placeholders)
- XSS prevention (ERB auto-escaping)
- CSRF protection (Rails default)
- Strong Parameters
- Authorization checks

---

## Troubleshooting

### Container Issues

```bash
# Clean restart
docker compose --env-file .env.development down -v
docker compose --env-file .env.development up -d

# Rebuild from scratch
docker compose --env-file .env.development build --no-cache
docker compose --env-file .env.development up -d
```

### Database Issues

```bash
# Access container
make bash

# Inside container:
rails db:reset
rails db:migrate
```

### Permission Issues

If you encounter permission issues with files created by Docker:

```bash
# Fix ownership (run on host)
sudo chown -R $(id -u):$(id -g) .
```

---

## Important Notes

1. **First-time setup**: Run `make init` only once to create the Rails application
2. **Environment configuration**: Edit `.env.development` or `.env.production` to change settings
3. **Volume persistence**: Gems and database data persist across container restarts
4. **Port conflicts**: Ensure ports 3000 and 5432 are available
5. **Make commands**: Run `make help` to see all available commands
6. **Environment files**: Use `--env-file` to explicitly specify which environment to use
