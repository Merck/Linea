Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 


Linea
========
Linea is a [DocGraph](https://www.docgraph.com/) tool that is designed to be a digital catalogue of publically available healthcare related datasets.


## Guidelines
Note: All of these come directly from the Linea readme when this readme was made. Most of these rules are still relevant, especially 2 and 5.1 .

Please observe the following rules when contributing to this project:

1. All code in the master branch is deployable, EC2 instances read from master anytime an instances is started
2. All development must occur in feature branches.
3. All code must be written test first using rspec.
4. You should push your branch changes to stash at least once a day, if not more.
5. Before pushing code or making a pull request, run the following:
	1. ` rake Linea:quality:rubocop ` and ` rake Linea:quality:slim ` to see if you have any quality issues to fix. 
	2. ` rake Linea:security ` to see if you've introduced security issues




## Deployment

Please see the associated deployment instructions file, [linea\_deployment\_instructions.md](./linea_docs/linea_deployment_instructions.md). 

## Importing Previous Data
Please see the associated database migration instructions file, [database\_migration\_instructions.md](./linea_docs/database_migration_instructions.md)

## Local Development
Local development requires the following to be installed:

 * brew and Xcode command line utilities (when on Mac) - see [http://brew.sh/](http://brew.sh/)
 * [rvm](https://rvm.io/)
 * [Git](http://git-scm.com/)
 * Ruby 2.2.5
 * Postgres 9.3.x

### Installing Ruby
If you're developing on a mac, you will need to install gnupg prior to install ruby and rvm:

```
brew install gnupg gnupg2
```

Install rvm:

```
# fetch key for rvm
command curl -sSL https://rvm.io/mpapis.asc | sudo gpg2 --import -

# install rvm
\curl -L https://get.rvm.io | bash -s stable

# add the rvm script to your .bash_profile 
echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile

# logout/login (to load rvm) or open another console window
# load latest rvm
rvm get head
rvm install 2.2.5 --patch railsexpress
rvm use 2.2.5@global
gem install bundler
```

### Installing LauchRocket (mac)
[LaunchRocket](https://github.com/jimbojsb/launchrocket) is a Mac PreferencePane that can be used to graphically start services such as ElasticSearch, Redis, MySQL, Postgresql, etc.. 

```
brew cask install launchrocket 
```

### Installing ElasticSearch (mac)

```
brew install Caskroom/cask/java
brew install elasticsearch
brew info elasticsearch
```

If you would like to forgo using LaunchRocket, you can follow these instructions:

```
# To have launchd start elasticsearch at login:
ln -sfv /usr/local/opt/elasticsearch/*.plist ~/Library/LaunchAgents

# Then to load elasticsearch now:
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.elasticsearch.plist

# Or, if you don't want/need launchctl, you can just run:
elasticsearch --config=/usr/local/opt/elasticsearch/config/elasticsearch.yml
```

### Installing Postgres
The following assumes you have [Homebrew](http://brew.sh/) installed.

Start by installing postgres:

```
brew update
brew install postgres
brew info postgres
```

Create a default database/confguration:

```
initdb /usr/local/var/postgres
```

Add the following to your ` ~/.bash_profile `:

```
echo 'export PGHOST=localhost' >> ~/.bash_profile
```

Load the previous change with ` source ~/.bash_profile `.

### Installing redis
Infomation about redis: [http://redis.io](http://redis.io)

* either use brew (` brew install redis `)

or

* download latest version somewhere (~/tmp for example)
* ` wget http://download.redis.io/releases/redis-3.2.0.tar.gz `
* unpack redis-3.2.0.tar.gz
* run ` make `
* start redis with ` src/redis-server `

### Installing sidekiq
```
gem install sidekiq
```

### Environment Setup
The following assumes that SSH keys have been set up where this repository resides

#### Installing the gems and adding necessary files
```
# Get the latest code from stash
git clone repository link
cd Linea

# switch over to rvm 2.2.5@global if not already
rvm use 2.2.5@global

# copy over a few files
cp config/database.yml.sample config/database.yml
cp config/google_oauth.yml.sample config/google_oauth.yml
cp .env.example .env.development 
cp .env.example .env.test

# install the other gems via bundler
bundle install
```

If you receive errors with libv8 while trying to bundle install, follow these instructions:

```
brew tap homebrew/versions
brew install v8-315

gem install libv8 -v '3.16.14.13' -- --with-system-v8
gem install therubyracer -- --with-v8-dir=/usr/local/opt/v8-315

bundle install
```

#### Bootstrapping and starting up
Start Redis, Postgresql, and ElasticSearch from the LaunchRocket preference pane. 

##### Bootstrapping
Open up the Linea project in the text editor of your choice. Navigate to bin/setup and uncomment lines 18 and 20.

In your open terminal window, execute:

`bin/setup`

Go back into bin/setup and recomment lines 18 and 20.

##### Startup
Open up a new terminal window in the Linea directory and start sidekiq:
```
bundle exec sidekiq –c 5 –e development –P ./tmp/sidekiq.pid –r ./ -q elastic –q sidekiq
```

Assuming that everything went well, you should now be able to launch Linea from the folder using 

`rails server`

Linea should now be available in your web browser at [http://localhost:3000](http://localhost:3000).


##### Note
If you receive an error with Google Oauth after the server has been started and you attempt to log in, regenerate client id and client secret and edit the `google_oauth.yml` file as per the oauth section of the [deployment instructions](./linea_docs/linea_deployment_instructions.md).

