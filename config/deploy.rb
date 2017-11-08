# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'tmpdir'

# Used to schedule cron jobs
#set :whenever_environment, defer { rails_env }
#set :whenever_command, 'bundle exec whenever'
#set :whenever_roles, :cron
#require 'whenever/capistrano'

# Setup a multistage deployment
set :stages, %w(production staging uat)
set :default_stage, 'staging'

# rvm
set :rvm_type, :system
set :rvm_ruby_version, '2.2.5'
set :rvm_remap_bins, %w{eye}

# Do assets with app role so NewRelic is happy and records the deploy
set :assets_roles, [:app]
set :rake, 'bundle exec rake'

# App Hostname
set :short_name, 'Linea'

# Application name
# it has to be set as 'Linea' as this is Project name tag in ec2 Or make sure it matches your Project name tag in ec2
set :application, 'Linea'#.company.com'
# and another 'nice' thing is that folder in deploy, so this is dirty workaround
set :application_folder, "#{fetch(:application)}.company.com"

# ec2 config
set :ec2_project_tag, 'Project'
set :ec2_roles_tag, 'Roles'
set :ec2_stages_tag, 'Stages'
set :ec2_region, %w{us-east-1}

# Don't use root, ever
set :use_sudo, false

# git is our SCM
set :scm, :git
set :copy_exclude, ['.git']

# Use github repository
set :repo_url, "add your repo link"

# master is our default git branch
set :branch, 'master'

# Deploy via github
set :deploy_via, :remote_cache
set :deploy_to, "/apps/#{fetch(:application_folder)}"
set :log_level, :info

# Files
set :log_path, "/apps/#{fetch(:application_folder)}/shared/log/"
set :linked_files, fetch(:linked_files, []).push('config/database.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log','tmp/pids','tmp/cache','tmp/sockets','vendor/bundle','public/system', 'tmp/binlog')
set :symlinks, [
    { source: File.join(shared_path, 'config', "#{fetch(:short_name)}.env.#{fetch(:stage)}"),
      destination: '.env'
    }
  ]
set :ec2_config_files, [
    { source: "configuration/environment/#{fetch(:short_name)}.database.yml",
      destination: "#{shared_path}/config/database.yml"
    },
    { source: "configuration/environment/#{fetch(:short_name)}.env.#{fetch(:stage)}",
      destination: "#{shared_path}/config/#{fetch(:short_name)}.env.#{fetch(:stage)}"
    }
  ]

# The following are needed for EC2 to use SSH auth
# overwrite in stage file if needed
set :ec2_options, { ssh_options: {
    user: 'ec2-user',
    keys: File.join(ENV['HOME'], '.ec2', "your pem file to get in .pem"),
    forward_agent: false,
    auth_methods: %w(publickey password),
    password: 'Not allowed. Please use keys.'
  }}

# Set number of releases to keep when running cap deploy:cleanup
set :keep_releases, 5

# S3 bucket that contains deploys and configs, for example selfservice.company.com
set :bucket_name, 'selfservice.company.com'

# eye configs
set :eye_config_path, 'config/eye'
set :eye_config, "config/eye/Linea.eye"
set :eye_sidekiq_config, "#{fetch(:eye_config_path)}/sidekiq.sub.eye"
set :eye_unicorn_config, "#{fetch(:eye_config_path)}/unicorn.sub.eye"

def render(file, b)
  template = File.read("#{File.dirname(__FILE__)}/deploy/templates/#{file}.erb")
  ERB.new(template, nil, '-').result(b)
end

namespace :eye do
  task :check_config do
    on roles(:app) do |host|
      next unless host
      within release_path do
        execute :mkdir, "-p", "config/eye"
        config_file = release_path.join(fetch(:eye_config))
        if test "[ -e #{config_file} ]"
          execute :rm, config_file
        end
        buff = StringIO.new(render('Linea.eye', binding))
        upload! buff, config_file
      end
    end
  end

  task :sidekiq_config do
    on roles(:sidekiq), in: :sequence do |host|
      next unless host
      config_file = release_path.join(fetch(:eye_sidekiq_config))
      if test "[ -e #{config_file} ]"
        execute :rm, config_file
      end
      buff = StringIO.new(render('sidekiq.eye', binding))
      upload! buff, config_file
    end
  end

  task :unicorn_config do
    on roles(:unicorn), in: :sequence do |host|
      next unless host
      config_file = release_path.join(fetch(:eye_unicorn_config))
      if test "[ -e #{config_file} ]"
        execute :rm, config_file
      end
      buff = StringIO.new(render('unicorn.eye', binding))
      upload! buff, config_file
    end
  end

  # load eye config
  task :load do
    on roles([:sidekiq, :unicorn]) do |host|
      next unless host
      within release_path do
        config_file = release_path.join(fetch(:eye_config))
        with rails_env: fetch(:rails_env) do
          execute :eye, "load", config_file
        end
      end
    end
  end

  task :restart do
    on roles(:sidekiq) do |host|
      next unless host
      within release_path do
        execute :eye, 'info'
      end
    end
  end

  task :config do
    invoke 'eye:check_config'
    invoke 'eye:sidekiq_config'
    invoke 'eye:unicorn_config'
    invoke 'eye:load'
  end
end
after 'deploy:updating', 'eye:config'
after 'deploy:reverting', 'eye:load'

before 'deploy:check:linked_files', 'company:s3:ec2:download'

# Unicorn settings
#set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"
#set :unicorn_config_path, "/etc/unicorn/#{fetch(:short_name)}.company.com.conf.rb"

namespace :deploy do

  desc 'Restart sidekiq'
  task :restart_sidekiq do
    on roles(:sidekiq) do |host|
      next unless host
      within release_path do
        execute :eye, 'restart','sidekiq'
      end
    end
  end

  desc 'Restart unicorn'
  task :restart_unicorn do
    on roles(:unicorn) do |host|
      next unless host
      within release_path do
        execute :eye, 'restart','unicorn'
      end
    end
  end

  after :publishing, :restart_unicorn

  desc 'Run a task on a remote server.'
  # Invoke like this: cap uat rake:invoke task=elasticsearch:force_import
  task :invoke do
    fail 'no task provided' unless ENV['task']
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, ENV['task']
        end
      end
    end
  end

end

before 'deploy:published', 'deploy:restart_sidekiq'

# Add Maintenance Mode where applicable
#before 'deploy:stop', 'deploy:maintenance:enable'
#after 'deploy:publishing', 'deploy:maintenance:disable'
#before 'deploy:migrations', 'deploy:maintenance:enable'
#after 'deploy:migrations', 'deploy:maintenance:disable'
