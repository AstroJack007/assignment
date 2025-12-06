alter table public.leads enable row level security;

create policy "leads_select_policy"
on public.leads
for select
using (
  (current_setting('request.jwt.claims', true)::jsonb ->> 'tenant_id')::uuid = tenant_id
  AND (
    (current_setting('request.jwt.claims', true)::jsonb ->> 'role') = 'admin'
    OR
    owner_id = (current_setting('request.jwt.claims', true)::jsonb ->> 'user_id')::uuid
    OR
    EXISTS (
      SELECT 1 FROM user_teams ut_me
      JOIN user_teams ut_other ON ut_me.team_id = ut_other.team_id
      WHERE ut_me.user_id = (current_setting('request.jwt.claims', true)::jsonb ->> 'user_id')::uuid
      AND ut_other.user_id = leads.owner_id
    )
  )
);

create policy "leads_insert_policy"
on public.leads
for insert
with check (
  (current_setting('request.jwt.claims', true)::jsonb ->> 'tenant_id')::uuid = tenant_id
  AND
  (current_setting('request.jwt.claims', true)::jsonb ->> 'role') IN ('admin', 'counselor')
);
