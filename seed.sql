BEGIN;

INSERT INTO users (user_id, email, full_name, country_code, timezone, created_at) VALUES
(1, 'aisha.khan@example.com', 'Aisha Khan', 'IN', 'Asia/Kolkata', '2026-01-05 09:00:00+00'),
(2, 'liam.carter@example.com', 'Liam Carter', 'US', 'America/New_York', '2026-01-08 11:20:00+00'),
(3, 'sofia.martin@example.com', 'Sofia Martin', 'GB', 'Europe/London', '2026-01-11 14:45:00+00'),
(4, 'noah.lee@example.com', 'Noah Lee', 'CA', 'America/Toronto', '2026-01-14 07:30:00+00'),
(5, 'emma.garcia@example.com', 'Emma Garcia', 'ES', 'Europe/Madrid', '2026-01-17 13:10:00+00'),
(6, 'ryo.tanaka@example.com', 'Ryo Tanaka', 'JP', 'Asia/Tokyo', '2026-01-21 04:40:00+00'),
(7, 'olivia.chen@innovacorp.com', 'Olivia Chen', 'US', 'America/Los_Angeles', '2026-01-09 16:00:00+00'),
(8, 'ethan.smith@brightlabs.com', 'Ethan Smith', 'AU', 'Australia/Sydney', '2026-01-12 06:15:00+00'),
(9, 'mia.patel@urbanretail.com', 'Mia Patel', 'IN', 'Asia/Kolkata', '2026-01-19 10:25:00+00'),
(10, 'lucas.ross@finedge.com', 'Lucas Ross', 'SG', 'Asia/Singapore', '2026-01-23 03:55:00+00');

INSERT INTO freelancers (freelancer_id, headline, hourly_rate, availability_status, total_experience_years, created_at) VALUES
(1, 'Full-Stack Developer (React + Node.js)', 45.00, 'available', 5.5, '2026-01-05 09:05:00+00'),
(2, 'Data Analyst & SQL Specialist', 40.00, 'busy', 6.0, '2026-01-08 11:30:00+00'),
(3, 'UI/UX Designer for SaaS Products', 38.00, 'available', 4.5, '2026-01-11 15:00:00+00'),
(4, 'DevOps Engineer (AWS, Docker, CI/CD)', 55.00, 'away', 7.0, '2026-01-14 07:45:00+00'),
(5, 'Mobile App Developer (Flutter)', 42.00, 'available', 5.0, '2026-01-17 13:20:00+00'),
(6, 'AI Engineer (NLP & Recommender Systems)', 60.00, 'busy', 8.0, '2026-01-21 04:50:00+00');

INSERT INTO clients (client_id, company_name, industry, billing_verified, created_at) VALUES
(7, 'InnovaCorp', 'SaaS', TRUE, '2026-01-09 16:10:00+00'),
(8, 'BrightLabs', 'EdTech', TRUE, '2026-01-12 06:20:00+00'),
(9, 'UrbanRetail', 'E-commerce', TRUE, '2026-01-19 10:30:00+00'),
(10, 'FinEdge', 'FinTech', FALSE, '2026-01-23 04:00:00+00');

INSERT INTO categories (category_id, name, parent_category_id) VALUES
(1, 'Web Development', NULL),
(2, 'Mobile Development', NULL),
(3, 'Data Science & Analytics', NULL),
(4, 'Design & Creative', NULL),
(5, 'Cloud & DevOps', NULL),
(6, 'Machine Learning', 3);

INSERT INTO skills (skill_id, name) VALUES
(1, 'PostgreSQL'),
(2, 'Python'),
(3, 'React'),
(4, 'Node.js'),
(5, 'Figma'),
(6, 'AWS'),
(7, 'Docker'),
(8, 'Flutter'),
(9, 'TensorFlow'),
(10, 'Power BI'),
(11, 'TypeScript'),
(12, 'NLP');

INSERT INTO freelancer_skills (freelancer_id, skill_id, proficiency_level, years_experience) VALUES
(1, 3, 'expert', 5.0),
(1, 4, 'advanced', 4.8),
(1, 11, 'advanced', 4.0),
(1, 1, 'intermediate', 3.2),
(2, 1, 'expert', 6.0),
(2, 2, 'advanced', 5.5),
(2, 10, 'expert', 5.0),
(3, 5, 'expert', 4.5),
(3, 11, 'intermediate', 2.5),
(4, 6, 'expert', 6.5),
(4, 7, 'expert', 6.0),
(4, 2, 'advanced', 4.0),
(5, 8, 'expert', 5.0),
(5, 2, 'advanced', 3.8),
(6, 2, 'expert', 8.0),
(6, 9, 'advanced', 6.0),
(6, 12, 'expert', 5.5),
(6, 1, 'advanced', 4.2);

INSERT INTO portfolio_items (portfolio_item_id, freelancer_id, title, description, project_url, completed_on) VALUES
(1, 1, 'B2B Dashboard Revamp', 'Built a React + Node analytics dashboard for enterprise clients.', 'https://portfolio.example.com/aisha/dashboard', '2025-10-01'),
(2, 2, 'Retail Sales BI Suite', 'Created advanced SQL models and executive dashboards.', 'https://portfolio.example.com/liam/retail-bi', '2025-11-15'),
(3, 3, 'FinTech UX System', 'Designed design-system and high-fidelity prototypes.', 'https://portfolio.example.com/sofia/fintech-ux', '2025-12-04'),
(4, 4, 'Cloud Migration Pipeline', 'Automated CI/CD and Kubernetes deployment for SaaS stack.', 'https://portfolio.example.com/noah/cloud-pipeline', '2025-09-20'),
(5, 5, 'Fitness Mobile App', 'Developed cross-platform Flutter app with payment flow.', 'https://portfolio.example.com/emma/fitness-app', '2025-08-08'),
(6, 6, 'Support Chatbot', 'Implemented NLP-based support assistant with intent ranking.', 'https://portfolio.example.com/ryo/chatbot', '2025-12-22');

INSERT INTO projects (project_id, client_id, category_id, title, description, budget_type, budget_min, budget_max, currency_code, status, visibility, deadline, created_at) VALUES
(1, 7, 1, 'Build Multi-Tenant SaaS Admin Portal', 'Need a secure admin portal with role-based access and analytics.', 'fixed', 7000, 12000, 'USD', 'in_progress', 'public', '2026-08-15', '2026-02-01 10:00:00+00'),
(2, 8, 3, 'Student Performance Analytics Warehouse', 'Design data models and dashboards for learner analytics.', 'hourly', 35, 60, 'USD', 'completed', 'public', '2026-05-20', '2026-02-03 12:30:00+00'),
(3, 9, 2, 'Retail Companion Mobile App', 'Cross-platform app with personalized recommendations.', 'fixed', 5000, 9000, 'USD', 'in_progress', 'public', '2026-09-10', '2026-02-10 09:20:00+00'),
(4, 10, 5, 'CI/CD Modernization for FinTech API', 'Improve deployment reliability and release velocity.', 'hourly', 45, 80, 'USD', 'open', 'invite_only', '2026-08-01', '2026-02-12 06:50:00+00'),
(5, 7, 6, 'Customer Support NLP Assistant', 'Train intent classifier and deploy chatbot for support team.', 'fixed', 8000, 15000, 'USD', 'open', 'public', '2026-10-05', '2026-02-20 13:05:00+00'),
(6, 8, 4, 'Learning Platform UX Redesign', 'Complete UX audit and clickable prototype for web portal.', 'fixed', 3000, 5500, 'USD', 'completed', 'private', '2026-04-30', '2026-02-05 08:10:00+00'),
(7, 9, 1, 'E-commerce Checkout Optimization', 'Improve frontend performance and reduce cart abandonment.', 'hourly', 30, 55, 'USD', 'open', 'public', '2026-07-30', '2026-03-01 11:40:00+00'),
(8, 10, 3, 'Fraud Detection Reporting Layer', 'Build SQL-powered risk metrics reporting pipeline.', 'fixed', 6000, 11000, 'USD', 'open', 'public', '2026-09-25', '2026-03-03 04:15:00+00');

INSERT INTO project_skills (project_id, skill_id, importance) VALUES
(1, 3, 5), (1, 4, 5), (1, 11, 4), (1, 1, 3),
(2, 1, 5), (2, 2, 4), (2, 10, 5),
(3, 8, 5), (3, 2, 3),
(4, 6, 5), (4, 7, 5), (4, 2, 3),
(5, 2, 5), (5, 9, 4), (5, 12, 5),
(6, 5, 5),
(7, 3, 4), (7, 11, 4),
(8, 1, 5), (8, 2, 4);

INSERT INTO proposals (proposal_id, project_id, freelancer_id, proposed_rate, estimated_duration_days, cover_letter, status, submitted_at, responded_at) VALUES
(1, 1, 1, 9800, 45, 'I have built similar SaaS admin products and can deliver in phases.', 'accepted', '2026-02-02 09:00:00+00', '2026-02-04 10:00:00+00'),
(2, 1, 4, 52, 60, 'Can assist with infra and deployment automation for the same project.', 'rejected', '2026-02-02 10:30:00+00', '2026-02-05 09:15:00+00'),
(3, 2, 2, 42, 50, 'Strong SQL + BI experience for analytics warehouse implementations.', 'accepted', '2026-02-04 08:00:00+00', '2026-02-06 14:20:00+00'),
(4, 2, 6, 58, 35, 'Can combine analytics with predictive modeling extensions.', 'rejected', '2026-02-04 12:45:00+00', '2026-02-07 09:45:00+00'),
(5, 3, 5, 7800, 55, 'Flutter expert with multiple commerce mobile app deliveries.', 'accepted', '2026-02-11 07:10:00+00', '2026-02-13 15:00:00+00'),
(6, 3, 1, 8500, 60, 'Can build hybrid web-mobile API and integration.', 'rejected', '2026-02-11 11:20:00+00', '2026-02-14 09:00:00+00'),
(7, 4, 4, 58, 30, 'Deep DevOps experience in regulated FinTech environments.', 'submitted', '2026-02-13 06:30:00+00', NULL),
(8, 4, 2, 47, 45, 'Can support reporting side and deployment metrics tracking.', 'submitted', '2026-02-13 07:00:00+00', NULL),
(9, 5, 6, 13200, 70, 'I can deliver a production NLP assistant with evaluation pipeline.', 'submitted', '2026-02-21 05:40:00+00', NULL),
(10, 5, 2, 9800, 85, 'I can support data prep and feedback loop analytics.', 'submitted', '2026-02-21 09:15:00+00', NULL),
(11, 6, 3, 4200, 25, 'UX redesign with validated user-flow prototypes.', 'accepted', '2026-02-06 09:10:00+00', '2026-02-07 11:10:00+00'),
(12, 6, 1, 5000, 28, 'Can implement UX plus frontend improvements.', 'rejected', '2026-02-06 13:00:00+00', '2026-02-08 10:30:00+00'),
(13, 7, 1, 50, 35, 'Frontend performance optimization specialist.', 'submitted', '2026-03-02 10:00:00+00', NULL),
(14, 8, 2, 8800, 40, 'Strong SQL data modeling for risk and fraud insights.', 'submitted', '2026-03-04 06:20:00+00', NULL),
(15, 8, 6, 9800, 42, 'Can augment reporting with anomaly detection modules.', 'submitted', '2026-03-04 07:05:00+00', NULL);

INSERT INTO contracts (contract_id, project_id, freelancer_id, proposal_id, agreed_rate, billing_type, status, start_date, end_date, created_at) VALUES
(1, 1, 1, 1, 9800, 'fixed', 'active', '2026-02-06', NULL, '2026-02-06 10:05:00+00'),
(2, 2, 2, 3, 42, 'hourly', 'completed', '2026-02-08', '2026-05-18', '2026-02-08 09:00:00+00'),
(3, 3, 5, 5, 7800, 'fixed', 'active', '2026-02-15', NULL, '2026-02-15 16:00:00+00'),
(4, 6, 3, 11, 4200, 'fixed', 'completed', '2026-02-09', '2026-04-28', '2026-02-09 12:00:00+00');

INSERT INTO milestones (milestone_id, contract_id, title, description, due_date, amount, status, created_at) VALUES
(1, 1, 'Architecture & RBAC Blueprint', 'Define tenancy model and role matrix.', '2026-03-01', 2500, 'paid', '2026-02-06 10:30:00+00'),
(2, 1, 'Core Admin Modules', 'Build user, tenant, and permissions modules.', '2026-04-10', 3500, 'approved', '2026-02-06 10:35:00+00'),
(3, 1, 'Analytics + QA Hardening', 'Implement dashboards and testing.', '2026-05-20', 3800, 'overdue', '2026-02-06 10:40:00+00'),
(4, 2, 'Data Model & ETL Setup', 'Warehouse schema and ingestion jobs.', '2026-03-12', 3200, 'paid', '2026-02-08 09:10:00+00'),
(5, 2, 'Dashboard Delivery', 'Power BI dashboards and metrics definitions.', '2026-04-20', 3600, 'paid', '2026-02-08 09:15:00+00'),
(6, 2, 'Documentation & Handover', 'Playbook and stakeholder walkthrough.', '2026-05-15', 2400, 'paid', '2026-02-08 09:20:00+00'),
(7, 3, 'Mobile App Foundations', 'Auth, profile, and product listing.', '2026-03-25', 2600, 'paid', '2026-02-15 16:15:00+00'),
(8, 3, 'Recommendation & Checkout', 'Recommendation feed and payment flow.', '2026-05-10', 2900, 'in_progress', '2026-02-15 16:20:00+00'),
(9, 3, 'QA & Store Submission', 'Testing and release readiness.', '2026-06-15', 2300, 'pending', '2026-02-15 16:25:00+00'),
(10, 4, 'UX Audit + Prototype', 'Research findings and clickable prototype.', '2026-04-15', 4200, 'paid', '2026-02-09 12:15:00+00');

INSERT INTO payments (payment_id, contract_id, milestone_id, payer_client_id, payee_freelancer_id, amount, currency_code, payment_method, status, created_at, paid_at) VALUES
(1, 1, 1, 7, 1, 2500, 'USD', 'bank_transfer', 'completed', '2026-03-02 08:00:00+00', '2026-03-02 08:05:00+00'),
(2, 2, 4, 8, 2, 3200, 'USD', 'card', 'completed', '2026-03-13 07:00:00+00', '2026-03-13 07:03:00+00'),
(3, 2, 5, 8, 2, 3600, 'USD', 'wallet', 'completed', '2026-04-21 09:30:00+00', '2026-04-21 09:31:00+00'),
(4, 2, 6, 8, 2, 2400, 'USD', 'bank_transfer', 'completed', '2026-05-16 06:40:00+00', '2026-05-16 06:45:00+00'),
(5, 3, 7, 9, 5, 2600, 'USD', 'card', 'completed', '2026-03-26 10:10:00+00', '2026-03-26 10:11:00+00'),
(6, 4, 10, 8, 3, 4200, 'USD', 'bank_transfer', 'completed', '2026-04-16 05:30:00+00', '2026-04-16 05:35:00+00'),
(7, 1, 2, 7, 1, 3500, 'USD', 'card', 'pending', '2026-04-11 10:20:00+00', NULL);

INSERT INTO reviews (review_id, contract_id, reviewer_user_id, reviewee_user_id, rating, comment, created_at) VALUES
(1, 1, 7, 1, 5, 'Excellent communication and architecture quality.', '2026-05-01 12:00:00+00'),
(2, 1, 1, 7, 5, 'Clear requirements and quick milestone approvals.', '2026-05-02 09:00:00+00'),
(3, 2, 8, 2, 4, 'Strong analytics work and timely delivery.', '2026-05-20 11:30:00+00'),
(4, 2, 2, 8, 5, 'Great collaboration and well-defined KPIs.', '2026-05-21 08:20:00+00'),
(5, 4, 8, 3, 5, 'Outstanding UX output with practical user flows.', '2026-04-29 10:45:00+00'),
(6, 4, 3, 8, 4, 'Feedback was prompt and implementation-focused.', '2026-04-30 07:15:00+00');

INSERT INTO conversations (conversation_id, project_id, contract_id, created_at) VALUES
(1, 1, 1, '2026-02-02 09:30:00+00'),
(2, 4, NULL, '2026-02-13 08:00:00+00'),
(3, 5, NULL, '2026-02-21 06:00:00+00'),
(4, 3, 3, '2026-02-16 10:10:00+00');

INSERT INTO conversation_participants (conversation_id, user_id, joined_at) VALUES
(1, 7, '2026-02-02 09:31:00+00'), (1, 1, '2026-02-02 09:31:00+00'),
(2, 10, '2026-02-13 08:01:00+00'), (2, 4, '2026-02-13 08:01:00+00'),
(3, 7, '2026-02-21 06:01:00+00'), (3, 6, '2026-02-21 06:01:00+00'), (3, 2, '2026-02-21 06:02:00+00'),
(4, 9, '2026-02-16 10:11:00+00'), (4, 5, '2026-02-16 10:11:00+00');

INSERT INTO messages (message_id, conversation_id, sender_user_id, body, sent_at, is_read) VALUES
(1, 1, 7, 'Can you share the first architecture draft by Friday?', '2026-02-03 10:00:00+00', TRUE),
(2, 1, 1, 'Yes, I will deliver the blueprint and tenant flow diagrams.', '2026-02-03 10:25:00+00', TRUE),
(3, 2, 10, 'We need zero-downtime deployment support for this API.', '2026-02-13 08:15:00+00', TRUE),
(4, 2, 4, 'Understood, I can propose a blue-green rollout plan.', '2026-02-13 08:22:00+00', FALSE),
(5, 3, 6, 'I can include multilingual intent classification in scope.', '2026-02-21 06:10:00+00', TRUE),
(6, 3, 2, 'I can support analytics for chatbot feedback loops.', '2026-02-21 06:14:00+00', FALSE),
(7, 4, 9, 'Please prioritize checkout latency on older devices.', '2026-02-16 10:30:00+00', TRUE),
(8, 4, 5, 'Noted, performance budget and profiling are in progress.', '2026-02-16 10:45:00+00', TRUE);

-- Keep identity sequences aligned after explicit IDs
SELECT setval(pg_get_serial_sequence('users', 'user_id'), COALESCE(MAX(user_id), 1), TRUE) FROM users;
SELECT setval(pg_get_serial_sequence('categories', 'category_id'), COALESCE(MAX(category_id), 1), TRUE) FROM categories;
SELECT setval(pg_get_serial_sequence('skills', 'skill_id'), COALESCE(MAX(skill_id), 1), TRUE) FROM skills;
SELECT setval(pg_get_serial_sequence('portfolio_items', 'portfolio_item_id'), COALESCE(MAX(portfolio_item_id), 1), TRUE) FROM portfolio_items;
SELECT setval(pg_get_serial_sequence('projects', 'project_id'), COALESCE(MAX(project_id), 1), TRUE) FROM projects;
SELECT setval(pg_get_serial_sequence('proposals', 'proposal_id'), COALESCE(MAX(proposal_id), 1), TRUE) FROM proposals;
SELECT setval(pg_get_serial_sequence('contracts', 'contract_id'), COALESCE(MAX(contract_id), 1), TRUE) FROM contracts;
SELECT setval(pg_get_serial_sequence('milestones', 'milestone_id'), COALESCE(MAX(milestone_id), 1), TRUE) FROM milestones;
SELECT setval(pg_get_serial_sequence('payments', 'payment_id'), COALESCE(MAX(payment_id), 1), TRUE) FROM payments;
SELECT setval(pg_get_serial_sequence('reviews', 'review_id'), COALESCE(MAX(review_id), 1), TRUE) FROM reviews;
SELECT setval(pg_get_serial_sequence('conversations', 'conversation_id'), COALESCE(MAX(conversation_id), 1), TRUE) FROM conversations;
SELECT setval(pg_get_serial_sequence('messages', 'message_id'), COALESCE(MAX(message_id), 1), TRUE) FROM messages;

COMMIT;
