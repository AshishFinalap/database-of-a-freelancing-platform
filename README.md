# Database of a Freelancing Platform (PostgreSQL)

This repository contains a complete, portfolio-ready PostgreSQL database project for a modern freelancing platform. It demonstrates ER-style domain modeling, BCNF-oriented normalization, production-style DDL, coherent seed data, and advanced analytical queries for realistic platform workflows.

## Project Overview

The database models end-to-end freelancing operations:

- User accounts for both freelancers and clients
- Freelancer capabilities (skills, portfolio)
- Client project posting and required skills
- Bidding lifecycle (proposals)
- Contract execution and milestone tracking
- Payments and ratings/reviews
- Messaging/conversation records for project communication

## ER Model Summary

### Main Entities

- `users` (base identity for all participants)
- `freelancers` (1:1 extension of users)
- `clients` (1:1 extension of users)
- `skills`, `categories`
- `freelancer_skills` (M:N freelancer ↔ skill)
- `projects` (client-posted jobs)
- `project_skills` (M:N project ↔ skill)
- `proposals` (freelancer bids per project)
- `contracts` (accepted engagement)
- `milestones` (contract deliverables)
- `payments` (financial records)
- `reviews` (mutual feedback)
- `conversations`, `conversation_participants`, `messages`
- `portfolio_items` (freelancer showcase)

### Cardinalities (high-level)

- `users` 1:0..1 `freelancers`
- `users` 1:0..1 `clients`
- `clients` 1:N `projects`
- `projects` M:N `skills` via `project_skills`
- `freelancers` M:N `skills` via `freelancer_skills`
- `projects` 1:N `proposals`
- `projects` 1:N `contracts` (schema allows multiple project-freelancer pairs)
- `contracts` 1:N `milestones`
- `contracts` 1:N `payments`
- `contracts` 1:N `reviews` (one per reviewer per contract)
- `conversations` 1:N `messages`
- `conversations` M:N `users` via `conversation_participants`

## BCNF / Normalization Notes

The schema is designed to be in BCNF (or very close where business flexibility is preferred):

1. **User specialization**: `freelancers` and `clients` are separate 1:1 extension tables keyed by `user_id`, avoiding nullable role columns and update anomalies.
2. **M:N relationships decomposed**: `freelancer_skills` and `project_skills` resolve multi-valued dependencies.
3. **Functional dependencies kept local**:
   - `users`: `user_id → email, full_name, country_code, timezone`
   - `projects`: `project_id → client_id, category_id, title, budget fields, status...`
   - `proposals`: `proposal_id → project_id, freelancer_id, proposed_rate, status...`
4. **Candidate key enforcement**:
   - `users.email` unique
   - `proposals(project_id, freelancer_id)` unique (one active bid per freelancer/project pair)
   - `freelancer_skills(freelancer_id, skill_id)` and `project_skills(project_id, skill_id)` composite keys
5. **Domain integrity** via CHECK constraints (status enums, currency formats, value ranges, date logic).

## Files

- `/home/runner/work/database-of-a-freelancing-platform/database-of-a-freelancing-platform/schema.sql`
- `/home/runner/work/database-of-a-freelancing-platform/database-of-a-freelancing-platform/seed.sql`
- `/home/runner/work/database-of-a-freelancing-platform/database-of-a-freelancing-platform/queries.sql`

## PostgreSQL Setup

### Prerequisites

- PostgreSQL 14+ (project validated with PostgreSQL 16 syntax)
- `psql` CLI

### Create a database

```sql
CREATE DATABASE freelancing_platform;
```

### Run schema and seed

```bash
psql -d freelancing_platform -f schema.sql
psql -d freelancing_platform -f seed.sql
```

### Execute advanced queries

```bash
psql -d freelancing_platform -f queries.sql
```

## What the queries demonstrate

`queries.sql` includes 18 advanced examples covering:

- Top freelancers by earnings
- Proposal acceptance rates
- Project completion statistics
- Overdue milestone tracking
- Client spending analysis
- Skill demand trends
- Monthly revenue
- Category-wise average ratings
- Active contract pipeline
- Response-time analytics
- Window-function ranking and conversion funnel insights

These queries are written to be interview/recruiter friendly while still representing realistic marketplace analytics.
