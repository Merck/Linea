# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
#! /bin/bash
#
# Backup Restore Script
#
# This script automates the process of restoring Linea's PostgreSQL
# from a backup.
#
# Useage:
#   >bash linea_docs/backup_restore.sh /full/path/to/backup_2016_.._56.sql.gz
#
# Note: only execute this from the root of the linea directory!!



# Check to make sure that the archive exists before proceeding
if [ ! -f $1 ]; then
  echo "Error: file" $1 "does not exist."
  exit 1
fi

# Check to make sure that redis, sidekick, and unicorn rails aren't
# running before proceeding
function get_pid() {
  echo `ps -fe | grep $1 | grep -v grep | tr -s " "|cut -d" " -f2`
}

procs=("redis" "sidekiq" "unicorn_rails")
for i in "${procs[@]}"; do
  if [ -n "$(get_pid $i)" ]; then
    echo "Error: please shut down" $i "before trying to restore from a backup."
    exit 1
  fi
done


# Start the actual work...
echo "Dropping and recreating sampleDatabase_development...";
dropdb sampleDatabase_development;
createdb sampleDatabase_development;

echo "Importing data from the backup file...";
gunzip < $1 | psql -d sampleDatabase_development;

echo "Importing data into elastic search...";
bundle exec rake elasticsearch:force_import;

echo "All done :)";