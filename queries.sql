-- 1) Top freelancers by completed earnings
SELECT
    f.freelancer_id,
    u.full_name,
    SUM(p.amount) AS total_earned
FROM payments p
JOIN freelancers f ON f.freelancer_id = p.payee_freelancer_id
JOIN users u ON u.user_id = f.freelancer_id
WHERE p.status = 'completed'
GROUP BY f.freelancer_id, u.full_name
ORDER BY total_earned DESC;

-- 2) Proposal acceptance rate by freelancer
SELECT
    pr.freelancer_id,
    u.full_name,
    COUNT(*) AS total_proposals,
    COUNT(*) FILTER (WHERE pr.status = 'accepted') AS accepted_proposals,
    ROUND(100.0 * COUNT(*) FILTER (WHERE pr.status = 'accepted') / NULLIF(COUNT(*), 0), 2) AS acceptance_rate_pct
FROM proposals pr
JOIN users u ON u.user_id = pr.freelancer_id
GROUP BY pr.freelancer_id, u.full_name
ORDER BY acceptance_rate_pct DESC, total_proposals DESC;

-- 3) Project completion stats by client
SELECT
    c.client_id,
    u.full_name AS client_name,
    COUNT(*) AS total_projects,
    COUNT(*) FILTER (WHERE p.status = 'completed') AS completed_projects,
    ROUND(100.0 * COUNT(*) FILTER (WHERE p.status = 'completed') / NULLIF(COUNT(*), 0), 2) AS completion_rate_pct
FROM projects p
JOIN clients c ON c.client_id = p.client_id
JOIN users u ON u.user_id = c.client_id
GROUP BY c.client_id, u.full_name
ORDER BY completion_rate_pct DESC, total_projects DESC;

-- 4) Overdue milestones for active contracts
SELECT
    m.milestone_id,
    m.title,
    m.due_date,
    m.status,
    ct.contract_id,
    p.title AS project_title,
    fu.full_name AS freelancer_name,
    cu.full_name AS client_name
FROM milestones m
JOIN contracts ct ON ct.contract_id = m.contract_id
JOIN projects p ON p.project_id = ct.project_id
JOIN users fu ON fu.user_id = ct.freelancer_id
JOIN users cu ON cu.user_id = p.client_id
WHERE ct.status = 'active'
  AND m.status IN ('pending', 'in_progress', 'submitted', 'approved', 'overdue')
  AND m.due_date < CURRENT_DATE
ORDER BY m.due_date ASC;

-- 5) Client spending analysis (completed payments)
SELECT
    c.client_id,
    u.full_name AS client_name,
    cl.company_name,
    COUNT(p.payment_id) AS total_payments,
    SUM(p.amount) AS total_spent,
    AVG(p.amount) AS avg_payment_amount
FROM clients c
JOIN users u ON u.user_id = c.client_id
LEFT JOIN payments p
  ON p.payer_client_id = c.client_id
 AND p.status = 'completed'
JOIN clients cl ON cl.client_id = c.client_id
GROUP BY c.client_id, u.full_name, cl.company_name
ORDER BY total_spent DESC NULLS LAST;

-- 6) Skill demand trends from open projects
SELECT
    s.skill_id,
    s.name AS skill_name,
    COUNT(*) AS open_project_demand
FROM project_skills ps
JOIN skills s ON s.skill_id = ps.skill_id
JOIN projects p ON p.project_id = ps.project_id
WHERE p.status = 'open'
GROUP BY s.skill_id, s.name
ORDER BY open_project_demand DESC, s.name;

-- 7) Monthly platform revenue (completed payments)
SELECT
    DATE_TRUNC('month', p.paid_at) AS revenue_month,
    SUM(p.amount) AS monthly_revenue
FROM payments p
WHERE p.status = 'completed'
GROUP BY DATE_TRUNC('month', p.paid_at)
ORDER BY revenue_month;

-- 8) Average freelancer rating by project category
SELECT
    cat.name AS category,
    ROUND(AVG(r.rating)::NUMERIC, 2) AS avg_freelancer_rating,
    COUNT(r.review_id) AS review_count
FROM reviews r
JOIN contracts ct ON ct.contract_id = r.contract_id
JOIN projects p ON p.project_id = ct.project_id
JOIN categories cat ON cat.category_id = p.category_id
WHERE r.reviewee_user_id = ct.freelancer_id
GROUP BY cat.name
ORDER BY avg_freelancer_rating DESC, review_count DESC;

-- 9) Active contract pipeline with progress amount by contract
WITH milestone_progress AS (
    SELECT
        m.contract_id,
        SUM(m.amount) AS total_milestone_amount,
        SUM(m.amount) FILTER (WHERE m.status = 'paid') AS paid_milestone_amount
    FROM milestones m
    GROUP BY m.contract_id
)
SELECT
    ct.contract_id,
    p.title AS project_title,
    fu.full_name AS freelancer_name,
    cu.full_name AS client_name,
    ct.status,
    COALESCE(mp.total_milestone_amount, 0) AS total_scope_amount,
    COALESCE(mp.paid_milestone_amount, 0) AS paid_scope_amount,
    ROUND(
        100.0 * COALESCE(mp.paid_milestone_amount, 0) / NULLIF(mp.total_milestone_amount, 0),
        2
    ) AS paid_progress_pct
FROM contracts ct
JOIN projects p ON p.project_id = ct.project_id
JOIN users fu ON fu.user_id = ct.freelancer_id
JOIN users cu ON cu.user_id = p.client_id
LEFT JOIN milestone_progress mp ON mp.contract_id = ct.contract_id
WHERE ct.status IN ('active', 'paused')
ORDER BY paid_progress_pct DESC NULLS LAST;

-- 10) Proposal response time (hours) by client
SELECT
    p.client_id,
    u.full_name AS client_name,
    ROUND(AVG(EXTRACT(EPOCH FROM (pr.responded_at - pr.submitted_at)) / 3600)::NUMERIC, 2) AS avg_response_hours
FROM proposals pr
JOIN projects p ON p.project_id = pr.project_id
JOIN users u ON u.user_id = p.client_id
WHERE pr.responded_at IS NOT NULL
GROUP BY p.client_id, u.full_name
ORDER BY avg_response_hours;

-- 11) Freelancer ranking by category using window functions
WITH earnings_by_category AS (
    SELECT
        cat.category_id,
        cat.name AS category_name,
        ct.freelancer_id,
        SUM(py.amount) FILTER (WHERE py.status = 'completed') AS earnings
    FROM contracts ct
    JOIN projects p ON p.project_id = ct.project_id
    JOIN categories cat ON cat.category_id = p.category_id
    LEFT JOIN payments py ON py.contract_id = ct.contract_id
    GROUP BY cat.category_id, cat.name, ct.freelancer_id
)
SELECT
    ebc.category_name,
    u.full_name AS freelancer_name,
    COALESCE(ebc.earnings, 0) AS earnings,
    DENSE_RANK() OVER (
        PARTITION BY ebc.category_id
        ORDER BY COALESCE(ebc.earnings, 0) DESC
    ) AS earnings_rank_in_category
FROM earnings_by_category ebc
JOIN users u ON u.user_id = ebc.freelancer_id
ORDER BY ebc.category_name, earnings_rank_in_category;

-- 12) Open projects with proposal volume and avg bid
SELECT
    p.project_id,
    p.title,
    COUNT(pr.proposal_id) AS proposal_count,
    ROUND(AVG(pr.proposed_rate)::NUMERIC, 2) AS avg_proposed_rate,
    MIN(pr.proposed_rate) AS min_proposed_rate,
    MAX(pr.proposed_rate) AS max_proposed_rate
FROM projects p
LEFT JOIN proposals pr ON pr.project_id = p.project_id
WHERE p.status = 'open'
GROUP BY p.project_id, p.title
ORDER BY proposal_count DESC, p.project_id;

-- 13) Conversion funnel: open projects -> accepted proposal -> contract
WITH accepted_projects AS (
    SELECT DISTINCT project_id
    FROM proposals
    WHERE status = 'accepted'
),
contracted_projects AS (
    SELECT DISTINCT project_id
    FROM contracts
)
SELECT
    COUNT(*) FILTER (WHERE p.status = 'open') AS open_projects,
    COUNT(ap.project_id) AS projects_with_accepted_proposal,
    COUNT(cp.project_id) AS projects_with_contract
FROM projects p
LEFT JOIN accepted_projects ap ON ap.project_id = p.project_id
LEFT JOIN contracted_projects cp ON cp.project_id = p.project_id;

-- 14) Clients with highest average freelancer ratings received
SELECT
    c.client_id,
    u.full_name AS client_name,
    cl.company_name,
    ROUND(AVG(r.rating)::NUMERIC, 2) AS avg_rating_received,
    COUNT(r.review_id) AS total_reviews
FROM clients c
JOIN users u ON u.user_id = c.client_id
JOIN clients cl ON cl.client_id = c.client_id
LEFT JOIN reviews r ON r.reviewee_user_id = c.client_id
GROUP BY c.client_id, u.full_name, cl.company_name
ORDER BY avg_rating_received DESC NULLS LAST, total_reviews DESC;

-- 15) Conversation engagement: message counts and last activity
SELECT
    conv.conversation_id,
    COUNT(m.message_id) AS total_messages,
    MAX(m.sent_at) AS last_message_at,
    COUNT(DISTINCT m.sender_user_id) AS unique_senders
FROM conversations conv
LEFT JOIN messages m ON m.conversation_id = conv.conversation_id
GROUP BY conv.conversation_id
ORDER BY last_message_at DESC NULLS LAST;

-- 16) Freelancer utilization: active contracts and pending milestone value
WITH pending_milestone_value AS (
    SELECT
        ct.freelancer_id,
        SUM(m.amount) FILTER (WHERE m.status IN ('pending', 'in_progress', 'submitted', 'approved', 'overdue')) AS pending_value
    FROM contracts ct
    JOIN milestones m ON m.contract_id = ct.contract_id
    WHERE ct.status IN ('active', 'paused')
    GROUP BY ct.freelancer_id
)
SELECT
    f.freelancer_id,
    u.full_name,
    COUNT(ct.contract_id) FILTER (WHERE ct.status IN ('active', 'paused')) AS active_contracts,
    COALESCE(pmv.pending_value, 0) AS pending_milestone_value
FROM freelancers f
JOIN users u ON u.user_id = f.freelancer_id
LEFT JOIN contracts ct ON ct.freelancer_id = f.freelancer_id
LEFT JOIN pending_milestone_value pmv ON pmv.freelancer_id = f.freelancer_id
GROUP BY f.freelancer_id, u.full_name, pmv.pending_value
ORDER BY active_contracts DESC, pending_milestone_value DESC;

-- 17) Category-level budget competitiveness (budget vs proposal spread)
SELECT
    cat.name AS category,
    ROUND(AVG(p.budget_max - p.budget_min)::NUMERIC, 2) AS avg_budget_range,
    ROUND(AVG(pr.proposed_rate)::NUMERIC, 2) AS avg_bid,
    ROUND(STDDEV_POP(pr.proposed_rate)::NUMERIC, 2) AS bid_stddev
FROM categories cat
JOIN projects p ON p.category_id = cat.category_id
LEFT JOIN proposals pr ON pr.project_id = p.project_id
GROUP BY cat.name
ORDER BY avg_budget_range DESC NULLS LAST;

-- 18) Recently active freelancers by latest message timestamp
SELECT
    m.sender_user_id AS freelancer_id,
    u.full_name,
    MAX(m.sent_at) AS latest_message_at,
    COUNT(*) AS messages_sent
FROM messages m
JOIN freelancers f ON f.freelancer_id = m.sender_user_id
JOIN users u ON u.user_id = m.sender_user_id
GROUP BY m.sender_user_id, u.full_name
ORDER BY latest_message_at DESC;
