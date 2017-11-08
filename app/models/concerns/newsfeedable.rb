# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
# This meta programing marvel ensures that any activity that includes this module
# automatically puts a record into the newsfeed table when its created
# and deletes its record in the newsfeed table if the activity is destroy.
#
# It will also make sure that the relations are created between the newsfeed item and the activity.
#
# It very dynamic and only requires a "class_name_id" column in the newsfeed item
# table - and a belongs_to relation in the NewsfeedItem class to work.
#

module Newsfeedable
  extend ActiveSupport::Concern

  included do
    after_create :add_newsfeed_item
    before_destroy :remove_newsfeed_item
  end

  def add_newsfeed_item
    newsfeed_item = NewsfeedItem.create(dataset: dataset, user: user, created_at: created_at)

    # Figure out what kind of class I am - and convert from camelcase into a underscore symbol
    class_name_symbol = self.class.name.demodulize.underscore.to_sym

    # Check if newsfeed responds to the type of class we are - assign us to the newsfeed_item and save
    return unless newsfeed_item.respond_to? class_name_symbol
    newsfeed_item.send("#{class_name_symbol}=", self)
    newsfeed_item.save
  end

  def remove_newsfeed_item
    # Figure out what kind of class I am
    class_name_symbol = self.class.name.demodulize.underscore.to_sym

    # Search for a newsfeed item that has me
    NewsfeedItem.where(:"#{class_name_symbol}_id" => id).first.destroy
  end
end
