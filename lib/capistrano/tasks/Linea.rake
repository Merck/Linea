# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'httparty'

FEDERATION_HOST = 'enter your federation host url'
EC2_CONFIG_PATH = 'config/ec2.yml'
ENV_HELPER = "Sick of entering your credentials?\nStore them in your environment with CAP_USER and CAP_PASS.\n\n"

namespace :Linea do
  namespace :iam do
    # Get AWS keys from your key issuing service
    desc 'Get temporary credentials from AWS'
    task :load_credentials do
      response = HTTParty.get(
        FEDERATION_HOST + '/sdd your authentication url',
        basic_auth: basic_auth,
        verify: false
      )

      if response.response.code == '200'
        json_response = JSON.parse(response.body, symbolize_names: true)
        ENV['AWS_ACCESS_KEY_ID'] = json_response.fetch(:sessionId)
        ENV['AWS_SECRET_ACCESS_KEY'] = json_response.fetch(:sessionKey)
        ENV['AWS_SESSION_TOKEN'] = json_response.fetch(:sessionToken)
      else
        STDERR.puts "\e[31mAuth failed, could not load AWS credentials\e[0m"
        STDERR.printf("%s\n%s\n%s\n", '-' * 80, response, '-' * 80)
        exit
      end

      add_credentials_to_capify_config
    end

    desc 'Remove temporary credentails from config/ec2.yml'
    task :remove_credentials do
      remove_credentials_from_capify_config
    end
  end

  namespace :maintenance do
    desc 'Load maintenance mode turning off access to the site'
    task :enable do
      on roles(:all, active: true) do
        run "cp #{release_path}/public/maintenance.html " \
            "#{release_path}/public/system/maintenance.html"
      end
    end

    desc 'Turn off maintenance mode'
    task :disable do
      on roles(:all, active: true) do
        run "rm -f #{release_path}/public/system/maintenance.html"
      end
    end
  end

end

private

def basic_auth
  {
    username: username,
    password: password
  }
end

def username
  ENV.fetch('CAP_USER') do
    print ENV_HELPER + "\e[32mEnter your ISID: \e[0m"
    $stdin.gets.chomp
    #ask(:cap_user, nil)
  end
end

def password
  ENV.fetch('CAP_PASS') do
    print "\e[32mEnter your password: \e[0m"
    $stdin.noecho(&:gets).chomp
    #ask(:cap_password, nil, echo: false)
  end
end

def ec2_config_as_yaml
  YAML.load_file(EC2_CONFIG_PATH) if File.exist?(EC2_CONFIG_PATH)
end

def save_ec2_config(contents)
  File.open(EC2_CONFIG_PATH, 'w') { |file| YAML.dump(contents, file) }
end

def add_credentials_to_capify_config
  modify_capify_config do |yaml|
    yaml[:access_key_id] = ENV['AWS_ACCESS_KEY_ID']
    yaml[:secret_access_key] = ENV['AWS_SECRET_ACCESS_KEY']
    yaml[:session_token] = ENV['AWS_SESSION_TOKEN']
  end
end

def remove_credentials_from_capify_config
  modify_capify_config do |yaml|
    yaml.delete(:access_key_id)
    yaml.delete(:secret_access_key)
    yaml.delete(:session_token)
  end
end

def modify_capify_config
  yaml = ec2_config_as_yaml || {}
  yield(yaml)
  save_ec2_config(yaml)
end
