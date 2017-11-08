# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
# Linea Deployment Instructions
### Some information before you begin installing
Linea was deployed on an ubuntu server, so this script will assume the same. Similarly, a seperate `deploy` user was used as well. Feel free to change this configuration as you see fit, just adjust package manager and distribution-specific commands as you see fit.


### Dependencies Install
##### Note:
There is a condensed install script included with the linea directory that you may use to expedite the dependency installation process. However, the script assumes that the app is being deployed on an ubuntu server, the deployment user has been created, that script is being ran as the deployment user, and that git has been install and configured to be able to access GitHub automatically (read: with a valid SSH key). 
If you would like to use this script, please see `condensed_dependency_install.sh` to automate the install.  If not, please see the following instructions to install the dependencies.


##### Detailed Install Instructions:
Before we begin, please note that all of these instructions assume that the location where linea is going to be installed is the home folder of a deployment user; i.e, the "linea directory" would be `/home/deploy/linea/`.

We will want to use a separate user to deploy Linea, add one and give it sudo privledges like so:

	sudo adduser deploy;
	sudo usermod -aG sudo deploy;
	
Now, you should switch over to your deployment user:
	
	su - deploy;

First, we will install git and gnupg (for rvm)

	sudo apt-get install git gnupg gnupg2;
	
Please note that in order to install Linea, you will need to use a github account, whether that is accomplished via SSH key, certificate authority or another means by the user's discretion. Don't forget your git configs:

	git config --global user.name "John Doe";
	git config --global user.email johndoe@example.com

Grab the latest version of Linea (probably a tar file) and extract it to the deploy user's home directory.

```
# assuming the archive is in /home/deploy/
tar -xvzf linea.tgz

cd linea/
```
	
Then, install rvm through these instructions.  You must use ruby version 2.2.5 as it is a critical to Linea's deployment.  If you encounter any issues with installing rvm, please see: [https://rvm.io/rvm/install](https://rvm.io/rvm/instal)

	gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3;
	
	\curl -sSL https://get.rvm.io | bash -s stable;
	
	\curl -sSL https://get.rvm.io | bash -s stable --ruby;
	
	rvm install ruby-2.2.5;
	
	source $HOME/.rvm/scripts/rvm;
	
	echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile; 
	
Install Rails
	
	gem install rails;

Install the Qt framework. Please note that synaptic is endemic to the APT manager, in case you are using a different distribution of linux.

	sudo apt-get install synaptic;
	sudo apt-get update;
	sudo apt-get install qt4-dev-tools libqt4-dev libqt4-core libqt4-gui;
	
We chose to install Java through a third-party PPA, as referenced here: [http://tecadmin.net/install-oracle-java-8-jdk-8-ubuntu-via-ppa/](http://tecadmin.net/install-oracle-java-8-jdk-8-ubuntu-via-ppa/). If you would rather install Java through Oracle, that's fine as well.

	sudo add-apt-repository ppa:webupd8team/java;
	sudo apt-get update;
	sudo apt-get install oracle-java8-installer;
	

Install Elastic Search. 

Note: Elastic seach and redis should be installed in the deployment user's home directory
	
	# change directories if necessary
	cd;
	
	curl -L -O https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.3.4/elasticsearch-2.3.4.tar.gz;
	
	tar -xvf elasticsearch-2.3.4.tar.gz;
	
Install redis

	wget http://download.redis.io/redis-stable.tar.gz;
	
	tar xvzf redis-stable.tar.gz;
	
	cd redis-stable && make && sudo make install;
	
Install PostgreSQL and its dependencies

	sudo apt-get install postgresql postgresql-contrib libpq-dev;
	
	echo ‘export PGHOST=’localhost’ >> ~/.bash_profile’ ’;
	
	sudo -u postgres createuser --superuser deploy;
	
Install sidekiq.
	
	# Make sure this is run from the linea directory
	gem install sidekiq;
	
Lastly, install bundler.  This will be used later to install the rest of Linea's gem dependencies.

	# Make sure this is run from the linea directory
	gem install bundler;
	
### Optional Automatic Start

This is an example of Linea starting at boot.  Use of this script at startup is not mandatory, however, you may want to keep it around anyway to easily start up all of Linea's dependencies at a moment's notice.

	#!/bin/bash
	su - deploy -c 'nohup /home/deploy/elasticsearch-2.3.4/bin/elasticsearch &>/dev/null &'
	su - deploy -c 'nohup redis-server  &>/dev/null &'
	su - deploy -c 'cd /home/deploy/linea && nohup bundle exec sidekiq –c 5 –e development –P ./tmp/sidekiq.pid –r ./ -q elastic –q sidekiq &>/dev/null &' 
	su - deploy -c 'cd /home/deploy/linea && nohup unicorn_rails &>/dev/null &'
	
*Placed inside /root/startup.sh*

	chmod +x /root/startup.sh
	
Edit the crontab (using crontab –e) on root and placed this at the end of the file on a new line:

	@reboot /root/startup.sh
	
### Configurations

Please execute
	
	bundle install

within the Linea directory.  If there are any errors, please ensure that bundler is installed.

Within the Linea directory, please execute

	cp .env.example .env.development
	cp .env.example .env.test
	cp config/database.yml.sample config/database.yml

Within bin/setup, please uncomment lines 18 and 20.  More specifically, these lines are

	psql postgres -c "drop role if exists sampleDatabase"
	psql postgres -c "create role sampleDatabase with createdb login password 'Linea567'" ||


Here are the example commmands to start redis, sidekiq and elasticsearch in their own screen instances.  


**Redis**
	
	screen -S redis -dm redis-server

**Elastic Search**

	screen -S elasticsearch -dm $HOME/elasticsearch-2.3.4/bin/elasticsearch


**Sidekiq**

	screen -S sidekiq -dm bundle exec sidekiq –c 5 –e development –P ./tmp/sidekiq.pid –r ./ -q elastic –q sidekiq
	
After these services are running, within the Linea directory please run

	bin/setup
#### OAuth Config

Each instance needs a set of credentials for accessing the Google APIs for OAuth. To set this up, log into a service gmail and head over to [ https://console.developers.google.com]( https://console.developers.google.com).

In the upper-right click **Select a Project** and then click **Create Project**. Add in the relevant information on the modal and then click **Create**.

Next, search for `contacts`, click on the **Contacts API** entry that pops up and then click the blue enable button. Go back and search for `google+`, click the **Google+ API** and then click the blue enable button.

Now, click the **Credentials** link on the left side of the screen. Then, click **Oauth Consent Screen**, fill in the details and save. 

Next click the blue button that says **Create Credentials** and choose **OAuth client ID**. Choose **Web application**, enter `http://YOURDOMAIN.COM/auth/google_oauth2/callback` under **Authorized redirect URIs**, then hit **Create**. Note: do NOT forget to change the domain, this detail is imperative for the execution of Google OAuth. You will then be presented with a client id and client secret, keep this window open for the next step.

Copy the sample oauth yml file for google:

	cp config/google_oauth.yml.sample config/google_oauth.yml

Open up the newly made file and replace the values of the client\_id and client\_secret with the new values you just generated.
	

Save and exit both the text editor and the Google credentials page.

#### Nginx Setup

In normal deployment, `unicorn` on port 8080 is used as the application server and linked with a reverse proxy (in our case `nginx`). In order to set up nginx to present Linea on port 80, place this example configuration in `/etc/ngnix/sites-enabled/`:

	server {
  			listen 80;
  			server_name __;
 		location / {
  			proxy_set_header Host $host;
  			proxy_pass http://localhost:8080;
 		}
	}

### Database Migration

This step is optional only if you do not have the current linea database.  If you do not have the current database from Linea, please see the [database\_migration\_instructions](./database_migration_instructions.md) within this directory for further instructions.

### S3 Backup

To set up Linea to be able to access an S3 instance for uploading zipped PostgreSQL dumps, open up `config/amazon_s3.yml` and replace the information with your S3 access details (access key and secret, bucket name and region). Please note, if you're not using temporary access keys with session tokens for manually run backups, ensure that `is_temporary_key` is set to `false` and not to touch `session_token`.

If you need help finding your access key and secret, follow this amazon link: [Getting Your Access Key ID and Secret Access Key](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html). 

If you need help creating an S3 bucket, follow this Amazon link: [Create a Bucket](http://docs.aws.amazon.com/AmazonS3/latest/gsg/CreatingABucket.html)

##### Manual Backups

To manually backup the database, run this command from the root of the linea directory:

```
bundle exec rake pg:backup
```

##### Automatic Backups

To have the backup run automatically, you need to set up a cron task. Open up the cron editor using `crontab -e` and add a line like this, which would run the backup task every night at midnight:

```
00 00 * * * /bin/bash -l -c 'cd /home/deploy/linea && bundle exec rake pg:backup --silent'
```

##### Restoring From a Backup File

Note: unicorn_rails, redis, and sidekiq cannot be running when you are restoring the database from a backup. Please ensure those processes are not running before proceeding.

To restore data from one of the backup files, first navigate to your S3 bucket and download your desired backup archive. Then, navigate to the root of the linea folder and execute

```
bash linea_docs/backup_restore.sh /full/path/to/backup_2016_.._56.sql.gz
``` 

### Final Steps
It is highly recommended that you restart the machine before starting the server.  Once restarted, please start redis, elastic search, and sidekiq.  Lastly, use
	
	unicorn_rails

to begin the server.



