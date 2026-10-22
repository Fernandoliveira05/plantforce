-- PlantForce · intenções de mentoria enviadas pelo formulário do site (index.html)
create table if not exists public.mentores (
  id                 uuid primary key default gen_random_uuid(),
  nome               text not null check (char_length(btrim(nome)) between 2 and 120),
  cargo              text not null check (char_length(btrim(cargo)) between 2 and 120),
  email              text not null check (
                       char_length(email) <= 254
                       and email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'
                     ),
  intencao_mentoria  boolean not null default true check (intencao_mentoria),
  created_at         timestamptz not null default now()
);

comment on table public.mentores is
  'Colaboradores da Salesforce que declararam intenção de mentorar um Jovem Semente no PlantForce (jan–abr 2027).';

-- Um registro por e-mail (sem diferenciar maiúsculas/minúsculas)
create unique index if not exists mentores_email_key on public.mentores (lower(email));

-- O site usa a chave pública: com RLS e só uma política de INSERT, ele pode inserir, mas nunca ler, editar ou apagar.
alter table public.mentores enable row level security;

grant insert on table public.mentores to anon, authenticated;

create policy "Site pode registrar intenção de mentoria"
  on public.mentores
  for insert
  to anon, authenticated
  with check (intencao_mentoria);
