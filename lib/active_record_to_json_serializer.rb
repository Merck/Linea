# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class ActiveRecordToJsonSerializer < Struct.new(:object)
  def to_hash
    @hash ||= hash_object(object)
  end

  private

  def hash_object(object)
    hash = {}
    hash.merge! object.attributes

    each_association_collection(object) do |association, association_name, item|
      path << object

      if assocation_has_collection?(association)
        hash[association_name] ||= []
        hash[association_name] << hash_object(item)
      else
        hash[association_name] = hash_object(item)
      end

      path.pop
    end

    hash.delete_if { |key, value| key == 'id' && value.nil? }
    hash.keys.each do |key|
      new_key = key.tr(' ', '_').camelize(:lower)
      hash[new_key] = hash.delete key
    end
    hash
  end

  def path
    @path ||= []
  end

  def assocation_has_collection?(association)
    [:has_many, :has_and_belongs_to_many].include? association.macro
  end

  def visited_object?(object)
    self.object == object || path.include?(object)
  end

  def each_association_collection(object)
    object.class.reflect_on_all_associations.each do |association|
      association_name = association.name.to_s

      association_collection(object, association_name).each do |item|
        yield(association, association_name, item) unless visited_object?(item)
      end
    end
  end

  def association_collection(object, association_name)
    object.send(association_name).to_a
  end

  def visited_objects
    @visited_objects ||= []
  end
end
