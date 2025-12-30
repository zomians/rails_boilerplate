# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Project Overview

This is a **Rails boilerplate** project using Docker for containerized development. The project is designed to quickly bootstrap new Rails applications with a standardized setup.

**Key Technologies:**
- Ruby (version configurable in `.env`)
- Rails (version configurable in `.env`)
- PostgreSQL (version configurable in `.env`)
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
docker compose ps

# View logs
docker compose logs app
docker compose logs db

# Stop containers
docker compose down

# Rebuild containers (after changing Dockerfile or dependencies)
docker compose build --no-cache

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

All versions and settings are configurable via `.env`:
- `RUBY_VERSION`: Ruby version (default: 3.3.6)
- `RAILS_VERSION`: Rails version (default: 8.0.4)
- `POSTGRES_VERSION`: PostgreSQL version (default: 16-bookworm)
- `APP_NAME`: Application name
- Database credentials (POSTGRES_USER, POSTGRES_PASSWORD, etc.)

### Project Structure

```
.
├── .env                 # Environment variables (versions, DB config)
├── compose.yaml         # Docker Compose configuration
├── Dockerfile.app       # App container definition
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
docker compose down -v
docker compose up -d

# Rebuild from scratch
docker compose build --no-cache
docker compose up -d
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
2. **Environment configuration**: Edit `.env` to change Ruby/Rails/PostgreSQL versions
3. **Volume persistence**: Gems and database data persist across container restarts
4. **Port conflicts**: Ensure ports 3000 and 5432 are available
5. **Make commands**: Run `make help` to see all available commands
