-- Add counter table to the supabase_realtime publication to allow listening for changes
alter publication supabase_realtime add table counter;

create policy "Enable realtime for all"
on public.counter
for select
using (true);