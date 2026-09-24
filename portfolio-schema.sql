-- Portfolio: dados administrativos no Neon do projeto Corretores.
-- Execute no banco "corretores" uma vez.
create table if not exists public.portfolio_settings (
  id boolean primary key default true,
  profile_image_data text,
  updated_at timestamptz not null default now(),
  constraint portfolio_settings_singleton check (id = true)
);

create table if not exists public.portfolio_projects (
  repo_name text primary key,
  title text not null,
  image_data text,
  updated_at timestamptz not null default now()
);

insert into public.portfolio_settings(id)
values(true)
on conflict(id) do nothing;

grant select on public.portfolio_settings, public.portfolio_projects to anonymous;
grant select, insert, update, delete on public.portfolio_settings, public.portfolio_projects to authenticated;

alter table public.portfolio_settings enable row level security;
alter table public.portfolio_projects enable row level security;

drop policy if exists portfolio_public_settings_read on public.portfolio_settings;
create policy portfolio_public_settings_read on public.portfolio_settings
for select to anonymous, authenticated using (true);

drop policy if exists portfolio_public_projects_read on public.portfolio_projects;
create policy portfolio_public_projects_read on public.portfolio_projects
for select to anonymous, authenticated using (true);

drop policy if exists portfolio_authenticated_settings on public.portfolio_settings;
create policy portfolio_authenticated_settings on public.portfolio_settings
for all to authenticated using (true) with check (true);

drop policy if exists portfolio_authenticated_projects on public.portfolio_projects;
create policy portfolio_authenticated_projects on public.portfolio_projects
for all to authenticated using (true) with check (true);
