create table public.counter (
  id uuid primary key default gen_random_uuid(),
  counter int default 0,
  username text not null,
  user_id uuid not null,
  constraint lists_owner_id_fkey foreign key (user_id) references auth.users (id) on delete cascade
) tablespace pg_default;
