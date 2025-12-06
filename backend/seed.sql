INSERT INTO public.leads (id, tenant_id, owner_id, email, full_name, stage, source)
VALUES
  ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'john.doe@example.com', 'John Doe', 'new', 'website'),
  ('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'jane.smith@example.com', 'Jane Smith', 'qualified', 'referral'),
  ('a2eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'mike.wilson@example.com', 'Mike Wilson', 'contacted', 'linkedin'),
  ('a3eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'sarah.jones@example.com', 'Sarah Jones', 'new', 'website'),
  ('a4eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'alex.brown@example.com', 'Alex Brown', 'qualified', 'event'),
  ('a5eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'emma.davis@example.com', 'Emma Davis', 'new', 'referral')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.applications (id, tenant_id, lead_id, stage, status)
VALUES
  ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'interview', 'open'),
  ('d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'a1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'document_review', 'open'),
  ('d2eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'a2eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'offer', 'open'),
  ('d3eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'a3eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'inquiry', 'open'),
  ('d4eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'a4eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'interview', 'open'),
  ('d5eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'a5eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'inquiry', 'open')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.tasks (id, tenant_id, application_id, type, title, status, due_at)
VALUES
  ('e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'call', 'Initial Call - John Doe', 'open', now() + interval '2 hours'),
  ('e1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'd4eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'call', 'Follow-up Call - Alex Brown', 'open', now() + interval '4 hours'),
  ('e2eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'd3eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'call', 'Discovery Call - Sarah Jones', 'open', now() + interval '6 hours'),
  ('e3eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'd1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'email', 'Send Program Details - Jane Smith', 'open', now() + interval '1 hour'),
  ('e4eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'd2eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'email', 'Send Offer Letter - Mike Wilson', 'open', now() + interval '3 hours'),
  ('e5eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'd5eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'email', 'Welcome Email - Emma Davis', 'open', now() + interval '5 hours'),
  ('e6eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'd1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'review', 'Document Review - Jane Smith', 'open', now() + interval '2 hours'),
  ('e7eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'd4eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'review', 'Application Review - Alex Brown', 'open', now() + interval '7 hours')
ON CONFLICT (id) DO UPDATE SET due_at = EXCLUDED.due_at, status = 'open';

INSERT INTO public.tasks (id, tenant_id, application_id, type, title, status, due_at)
VALUES
  ('f0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'email', 'Send Reminder', 'open', now() + interval '2 days'),
  ('f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'd1eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'call', 'Weekly Check-in', 'open', now() + interval '5 days'),
  ('f2eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'd2eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'review', 'Final Review', 'open', now() + interval '7 days')
ON CONFLICT (id) DO UPDATE SET due_at = EXCLUDED.due_at;
