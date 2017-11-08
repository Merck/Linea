# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
APP_PATH = '/apps/appname.company.com'
listen "#{APP_PATH}/shared/sockets/unicorn.sock", :backlog => 64

working_directory "#{APP_PATH}/current"
pid "#{APP_PATH}/shared/tmp/pids/unicorn.pid"
stderr_path "#{APP_PATH}/shared/log/unicorn.log"
stdout_path "#{APP_PATH}/shared/log/unicorn.log"

timeout 60

# Whether the app should be pre-loaded
preload_app true

# How many worker processes
worker_processes 31

# What to do before we fork a worker
before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

# What to do after we fork a worker
after_fork do |server, worker|
  # set process title to application name and git revision
  ENV['UNICORN_PROCTITLE'] = 'appname.company.com'
  revision_file = "#{APP_PATH}/current/REVISION"
  if File.exists?(revision_file)
    ENV['UNICORN_PROCTITLE'] = ENV['UNICORN_PROCTITLE'] + ' ' + File.read(revision_file)[0,6]
  end
  $0 = ENV['UNICORN_PROCTITLE']
  # reset sockets created before forking
  ActiveRecord::Base.establish_connection
end

