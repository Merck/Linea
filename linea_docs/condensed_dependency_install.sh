# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
#! /bin/bash

# Condensed dependency install script for Linea/Linea deployment
#
#
# PLEASE NOTE: This script assumes that the app is being deployed on an ubuntu server,
# the deployment user has been created, that script is being ran as the deployment user,
# and that git has been install and configured to be able to access GitHub
# automatically (read: with a valid SSH key)
# If any of those conditions are not met, either fix them or follow the readme which
# contains more detail about the install process
#
# Useage:
#   >bash linea_docs/condensed_dependency_install.sh
#
# Note: only execute this script from the root of the linea directory!

sudo apt-get -y install synaptic;
sudo add-apt-repository ppa:webupd8team/java;
sudo apt-get update;

sudo apt-get -y install gnupg gnupg2 qt4-dev-tools libqt4-dev libqt4-core libqt4-gui oracle-java8-installer postgresql postgresql-contrib libpq-dev make;
echo ‘export PGHOST=’localhost’ >> ~/.bash_profile’ ’;
sudo -u postgres createuser --superuser deploy;


command curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -;
\curl -sSL https://get.rvm.io | bash -s stable;
\curl -sSL https://get.rvm.io | bash -s stable --ruby;
echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile;
source $HOME/.bash_profile;

rvm install ruby-2.2.5;
rvm use 2.2.5@global;
gem install rails sidekiq bundler;

cd;

curl -L -O https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.3.4/elasticsearch-2.3.4.tar.gz;
tar -xvf elasticsearch-2.3.4.tar.gz;

wget http://download.redis.io/redis-stable.tar.gz;
tar xvzf redis-stable.tar.gz;
cd redis-stable && make && sudo make install;