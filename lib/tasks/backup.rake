# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
namespace :pg do
  task backup: :environment do
    # Generate a new filepath for the backup
    backup_file = "#{Rails.root}/db/backup_#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}.sql.gz"

    # dump the database and zip it up
    sh "pg_dump sampleDatabase_test | gzip -c > #{backup_file}"

    # Send the backup to Amazon
    send_to_amazon(backup_file)

    # Remove the file on completion so we don't clog up our app
    File.delete(backup_file)
  end
end

def send_to_amazon(file_path)
  s3_config = YAML.load_file(Rails.root.join('config', 'amazon_s3.yml'))['default']
  file_name = File.basename(file_path)

  # Establish a Resource connection to the S3 instance
  s3 = Aws::S3::Resource.new(
    region: s3_config['region'],
    credentials: Aws::Credentials.new(s3_config['access_key_id'], s3_config['secret_access_key'], (s3_config['is_temporary_access'] ? s3_config['session_token'] : nil))
  )

  # Create a new object (space) in the bucket for the backup
  obj = s3.bucket(s3_config['bucket']).object(file_name)

  # Upload the zipped backup to the created object
  obj.upload_file(file_path)
end
