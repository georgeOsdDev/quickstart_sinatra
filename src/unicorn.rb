bestie_root = File.dirname(__FILE__)

worker_processes 10
working_directory bestie_root

timeout 300
preload_app true

# Use sock if you want to run befind Nginx. See also misc/nginx_sample
# listen "/var/tmp/unicorn.sock"
listen 4567

pid File.join(bestie_root, "unicorn.pid")

stderr_path File.join(bestie_root, "logs/unicorn.stderr.log")
stdout_path File.join(bestie_root, "logs/unicorn.stdout.log")
