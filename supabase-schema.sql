create table if not exists public.student_accounts (
  user_id uuid primary key references auth.users (id) on delete cascade,
  data jsonb not null default '{"expenses":[],"budget":0,"currency":"INR","profile":{"name":"Student","college":"","course":"","year":""}}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.student_accounts enable row level security;

revoke all on table public.student_accounts from public, anon;
grant select, insert, update on table public.student_accounts to authenticated;

drop policy if exists "Students can read their own account" on public.student_accounts;
create policy "Students can read their own account"
  on public.student_accounts for select
  to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "Students can create their own account" on public.student_accounts;
create policy "Students can create their own account"
  on public.student_accounts for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

drop policy if exists "Students can update their own account" on public.student_accounts;
create policy "Students can update their own account"
  on public.student_accounts for update
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
