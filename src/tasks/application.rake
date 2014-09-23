desc 'Run the app with specified port'
task :server do
  port = ENV['port'] || 4567
  puts "Application is running at port: #{port}"
  system "rackup -p #{port}"
end

desc 'Run the app in background with specified port'
task :daemon do
  port = ENV['port'] || 4567
  puts "Application start at port: #{port}"
  system "rackup -D -p #{port} -P sinatra.pid"
end

task :s => ["server"]
task :d => ["daemon"]
