# LearnLynk – Technical Assessment

## Setup

### Prerequisites
- Node.js 18+
- Supabase account

### Frontend
```bash
cd frontend
npm install
```

Create `frontend/.env.local` with your Supabase credentials:
```
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
```

Run the development server:
```bash
npm run dev
```

Visit: http://localhost:3000/dashboard

### Database
Run the following SQL files in your Supabase SQL Editor (in order):
1. `backend/schema.sql`
2. `backend/rls_policies.sql`
3. `backend/seed.sql`

### Edge Functions
Deploy using Supabase CLI:
```bash
npx supabase login
npx supabase link --project-ref YOUR_PROJECT_REF
npx supabase functions deploy create-task
```

Test the function (PowerShell):
```powershell
Invoke-RestMethod -Uri "https://YOUR_PROJECT.supabase.co/functions/v1/create-task" `
  -Method POST `
  -Headers @{Authorization="Bearer YOUR_ANON_KEY"; "Content-Type"="application/json"} `
  -Body '{"application_id": "d0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11", "task_type": "call", "due_at": "2025-12-07T12:00:00Z"}'
```

---

## Stripe Answer

1.  **Initiation**: When the user clicks "Pay", I insert a row into `payment_requests` with status 'pending' and the `application_id`.
2.  **Stripe Call**: Immediately after, I call the Stripe API to create a Checkout Session, passing `payment_requests.id` as `client_reference_id` to link the session.
3.  **Redirect**: I redirect the user to the Stripe Checkout URL returned by the API.
4.  **Storage**: I store the returned `stripe_session_id` in the `payment_requests` table to maintain a reference.
5.  **Webhooks**: I set up a webhook endpoint listening for the `checkout.session.completed` event.
6.  **Verification**: When the webhook fires, I verify the signature and extract the `client_reference_id` (my payment request ID).
7.  **Completion**: I update the `payment_requests` status to 'paid' and store transaction details from the event.
8.  **Application Update**: Finally, I trigger a database update to set the `applications` status to 'submitted' or 'paid' within the same transaction or immediately after.
