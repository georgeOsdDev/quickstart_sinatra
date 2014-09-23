@dir = "./"

worker_processes 2
working_directory @dir

timeout 300
listen 4567

pid "#{@dir}/unicorn.pid"

stderr_path "#{@dir}logs/unicorn.stderr.log"
stdout_path "#{@dir}logs/unicorn.stdout.log"
