BEGIN;

-- Core extensions (for future UUID/token support if needed)
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Drop in dependency-safe order
DROP TABLE IF EXISTS messages CASCADE;
DROP TABLE IF EXISTS conversation_participants CASCADE;
DROP TABLE IF EXISTS conversations CASCADE;
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS milestones CASCADE;
DROP TABLE IF EXISTS contracts CASCADE;
DROP TABLE IF EXISTS proposals CASCADE;
DROP TABLE IF EXISTS project_skills CASCADE;
DROP TABLE IF EXISTS projects CASCADE;
DROP TABLE IF EXISTS portfolio_items CASCADE;
DROP TABLE IF EXISTS freelancer_skills CASCADE;
DROP TABLE IF EXISTS skills CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS clients CASCADE;
DROP TABLE IF EXISTS freelancers CASCADE;
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
    user_id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    full_name VARCHAR(120) NOT NULL,
    country_code CHAR(2) NOT NULL,
    timezone VARCHAR(60) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CHECK (country_code ~ '^[A-Z]{2}$')
);

CREATE TABLE freelancers (
    freelancer_id BIGINT PRIMARY KEY REFERENCES users(user_id) ON DELETE CASCADE,
    headline VARCHAR(180) NOT NULL,
    hourly_rate NUMERIC(10,2) NOT NULL CHECK (hourly_rate >= 0),
    availability_status VARCHAR(20) NOT NULL DEFAULT 'available',
    total_experience_years NUMERIC(4,1) NOT NULL CHECK (total_experience_years >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CHECK (availability_status IN ('available', 'busy', 'away'))
);

CREATE TABLE clients (
    client_id BIGINT PRIMARY KEY REFERENCES users(user_id) ON DELETE CASCADE,
    company_name VARCHAR(180) NOT NULL,
    industry VARCHAR(100),
    billing_verified BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE categories (
    category_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE,
    parent_category_id BIGINT REFERENCES categories(category_id) ON DELETE SET NULL
);

CREATE TABLE skills (
    skill_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE freelancer_skills (
    freelancer_id BIGINT NOT NULL REFERENCES freelancers(freelancer_id) ON DELETE CASCADE,
    skill_id BIGINT NOT NULL REFERENCES skills(skill_id) ON DELETE CASCADE,
    proficiency_level VARCHAR(20) NOT NULL,
    years_experience NUMERIC(4,1) NOT NULL CHECK (years_experience >= 0),
    PRIMARY KEY (freelancer_id, skill_id),
    CHECK (proficiency_level IN ('beginner', 'intermediate', 'advanced', 'expert'))
);

CREATE TABLE portfolio_items (
    portfolio_item_id BIGSERIAL PRIMARY KEY,
    freelancer_id BIGINT NOT NULL REFERENCES freelancers(freelancer_id) ON DELETE CASCADE,
    title VARCHAR(180) NOT NULL,
    description TEXT,
    project_url VARCHAR(500),
    completed_on DATE,
    UNIQUE (freelancer_id, title)
);

CREATE TABLE projects (
    project_id BIGSERIAL PRIMARY KEY,
    client_id BIGINT NOT NULL REFERENCES clients(client_id) ON DELETE RESTRICT,
    category_id BIGINT NOT NULL REFERENCES categories(category_id) ON DELETE RESTRICT,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    budget_type VARCHAR(20) NOT NULL,
    budget_min NUMERIC(12,2) NOT NULL CHECK (budget_min >= 0),
    budget_max NUMERIC(12,2) NOT NULL CHECK (budget_max >= budget_min),
    currency_code CHAR(3) NOT NULL DEFAULT 'USD',
    status VARCHAR(20) NOT NULL DEFAULT 'open',
    visibility VARCHAR(20) NOT NULL DEFAULT 'public',
    deadline DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CHECK (budget_type IN ('fixed', 'hourly')),
    CHECK (status IN ('draft', 'open', 'in_progress', 'completed', 'cancelled')),
    CHECK (visibility IN ('public', 'private', 'invite_only')),
    CHECK (currency_code ~ '^[A-Z]{3}$')
);

CREATE TABLE project_skills (
    project_id BIGINT NOT NULL REFERENCES projects(project_id) ON DELETE CASCADE,
    skill_id BIGINT NOT NULL REFERENCES skills(skill_id) ON DELETE CASCADE,
    importance SMALLINT NOT NULL CHECK (importance BETWEEN 1 AND 5),
    PRIMARY KEY (project_id, skill_id)
);

CREATE TABLE proposals (
    proposal_id BIGSERIAL PRIMARY KEY,
    project_id BIGINT NOT NULL REFERENCES projects(project_id) ON DELETE CASCADE,
    freelancer_id BIGINT NOT NULL REFERENCES freelancers(freelancer_id) ON DELETE CASCADE,
    proposed_rate NUMERIC(12,2) NOT NULL CHECK (proposed_rate >= 0),
    estimated_duration_days INTEGER NOT NULL CHECK (estimated_duration_days > 0),
    cover_letter TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'submitted',
    submitted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    responded_at TIMESTAMPTZ,
    UNIQUE (project_id, freelancer_id),
    CHECK (status IN ('submitted', 'accepted', 'rejected', 'withdrawn')),
    CHECK (
        (status = 'submitted' AND responded_at IS NULL)
        OR (status IN ('accepted', 'rejected', 'withdrawn') AND responded_at IS NOT NULL)
    )
);

CREATE TABLE contracts (
    contract_id BIGSERIAL PRIMARY KEY,
    project_id BIGINT NOT NULL REFERENCES projects(project_id) ON DELETE RESTRICT,
    freelancer_id BIGINT NOT NULL REFERENCES freelancers(freelancer_id) ON DELETE RESTRICT,
    proposal_id BIGINT UNIQUE REFERENCES proposals(proposal_id) ON DELETE SET NULL,
    agreed_rate NUMERIC(12,2) NOT NULL CHECK (agreed_rate >= 0),
    billing_type VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    start_date DATE NOT NULL,
    end_date DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (project_id, freelancer_id),
    CHECK (billing_type IN ('fixed', 'hourly')),
    CHECK (status IN ('active', 'paused', 'completed', 'terminated')),
    CHECK (end_date IS NULL OR end_date >= start_date)
);

CREATE TABLE milestones (
    milestone_id BIGSERIAL PRIMARY KEY,
    contract_id BIGINT NOT NULL REFERENCES contracts(contract_id) ON DELETE CASCADE,
    title VARCHAR(180) NOT NULL,
    description TEXT,
    due_date DATE NOT NULL,
    amount NUMERIC(12,2) NOT NULL CHECK (amount >= 0),
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CHECK (status IN ('pending', 'in_progress', 'submitted', 'approved', 'paid', 'overdue'))
);

CREATE TABLE payments (
    payment_id BIGSERIAL PRIMARY KEY,
    contract_id BIGINT NOT NULL REFERENCES contracts(contract_id) ON DELETE RESTRICT,
    milestone_id BIGINT REFERENCES milestones(milestone_id) ON DELETE SET NULL,
    payer_client_id BIGINT NOT NULL REFERENCES clients(client_id) ON DELETE RESTRICT,
    payee_freelancer_id BIGINT NOT NULL REFERENCES freelancers(freelancer_id) ON DELETE RESTRICT,
    amount NUMERIC(12,2) NOT NULL CHECK (amount > 0),
    currency_code CHAR(3) NOT NULL DEFAULT 'USD',
    payment_method VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    paid_at TIMESTAMPTZ,
    CHECK (currency_code ~ '^[A-Z]{3}$'),
    CHECK (payment_method IN ('card', 'bank_transfer', 'wallet')),
    CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
    CHECK (
        (status = 'completed' AND paid_at IS NOT NULL)
        OR (status <> 'completed')
    )
);

CREATE TABLE reviews (
    review_id BIGSERIAL PRIMARY KEY,
    contract_id BIGINT NOT NULL REFERENCES contracts(contract_id) ON DELETE CASCADE,
    reviewer_user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    reviewee_user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    rating SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (contract_id, reviewer_user_id),
    CHECK (reviewer_user_id <> reviewee_user_id)
);

CREATE TABLE conversations (
    conversation_id BIGSERIAL PRIMARY KEY,
    project_id BIGINT REFERENCES projects(project_id) ON DELETE CASCADE,
    contract_id BIGINT REFERENCES contracts(contract_id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CHECK (project_id IS NOT NULL OR contract_id IS NOT NULL)
);

CREATE TABLE conversation_participants (
    conversation_id BIGINT NOT NULL REFERENCES conversations(conversation_id) ON DELETE CASCADE,
    user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (conversation_id, user_id)
);

CREATE TABLE messages (
    message_id BIGSERIAL PRIMARY KEY,
    conversation_id BIGINT NOT NULL REFERENCES conversations(conversation_id) ON DELETE CASCADE,
    sender_user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT,
    body TEXT NOT NULL,
    sent_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_read BOOLEAN NOT NULL DEFAULT FALSE
);

-- Strategic indexes for frequent filters/joins
CREATE INDEX idx_projects_client_status_created ON projects (client_id, status, created_at DESC);
CREATE INDEX idx_projects_category ON projects (category_id);
CREATE INDEX idx_project_skills_skill ON project_skills (skill_id);
CREATE INDEX idx_freelancer_skills_skill ON freelancer_skills (skill_id, proficiency_level);
CREATE INDEX idx_proposals_project_status ON proposals (project_id, status);
CREATE INDEX idx_proposals_freelancer_status ON proposals (freelancer_id, status);
CREATE INDEX idx_contracts_freelancer_status ON contracts (freelancer_id, status);
CREATE INDEX idx_milestones_contract_status_due ON milestones (contract_id, status, due_date);
CREATE INDEX idx_payments_contract_paid_at ON payments (contract_id, paid_at);
CREATE INDEX idx_payments_payee_status ON payments (payee_freelancer_id, status);
CREATE INDEX idx_reviews_reviewee ON reviews (reviewee_user_id, created_at DESC);
CREATE INDEX idx_messages_conversation_sent_at ON messages (conversation_id, sent_at DESC);

COMMIT;
