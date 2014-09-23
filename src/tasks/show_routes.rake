desc "List all routes for this application"
task :routes do
  puts `grep -r '^[get|post|put|delete].*do$' app/controllers | sed 's/ do$//'`
end
