# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'tmpdir'
require 'fileutils'
require 'fog/aws'
namespace :company name do

  namespace :s3 do
    namespace :download do
      desc 'Download EC2 SSH keys'
      task :ec2_keys do
        local_path = File.join(ENV['HOME'], '.ec2', "#{fetch(:short_name)}-#{fetch(:rails_env)}.pem")
        remote_file = s3_bucket.files.get(
          "configuration/ec2/#{fetch(:short_name)}-#{fetch(:rails_env)}.pem"
        )
        FileUtils.mkdir_p File.join(ENV['HOME'], '.ec2')
        change_permissions(0700, local_path)
        File.open(local_path, 'w') do |file|
          file.write(remote_file.body)
        end
        change_permissions(0400, local_path)
        puts "File #{local_path} created."
      end
    end

    namespace :ec2 do
      desc 'Download configuration files from s3 to ec2 instance'
      task :download do
        next unless any? :ec2_config_files
        on release_roles(:app) do
          fetch(:ec2_config_files).each do |file|
            debug "Downloading S3:#{fetch(:bucket_name)}:#{file[:source]} to #{file[:destination]}"
            s3_file = s3_bucket.files.get(file[:source])
            buff = StringIO.new(s3_file.body)
            upload! buff, file[:destination]
          end
        end
      end

      desc 'Create specific symlinks'
      task :symlinks do
        next unless any? :symlinks
        on release_roles(:app) do
          fetch(:symlinks).each do |file|
            within release_path do
              next if test "[ -L #{file[:destination]} ]"
              debug "Linking #{file[:source]} to #{file[:destination]}"
              execute :rm, file[:destination] if test "[ -f #{file[:destination]} ]"
              execute :ln, "-s", file[:source], file[:destination]
            end
          end
        end
      end
    end
  end

  after 'deploy:symlink:shared', 'company:s3:ec2:symlinks'
end

private

def aws_configuration
  {
    provider: 'AWS',
    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    aws_session_token: ENV['AWS_SESSION_TOKEN'],
    path_style: true
  }
end

def s3_bucket
  Fog::Storage.new(aws_configuration).directories.get(fetch(:bucket_name))
end

def change_permissions(permissions, path)
  FileUtils.chmod(permissions, path)
rescue
  logger.debug "#{path} does not exist, did not change permissions."
end
