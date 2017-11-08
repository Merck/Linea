# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class JsonToActiveRecordSerializer < Struct.new(:klass, :data)
  def to_active_record
    hash_to_resource(klass: klass.class.to_s.constantize, data: data)
  end

  private

  def hash_to_resource(klass:, data:)
    instance = klass.new
    data.each do |key, value|
      key = key.to_s.underscore

      if (value.is_a? Array) && (!value.empty?) && key != "queries"
        target_class = instance.send(key).class.to_s.split('::')[0..-2].join('::').constantize

        value.each do |value2|
          value2 = { 'name' => value2 } unless value2.is_a? Hash
          instance.send(key) << hash_to_resource(klass: target_class, data: value2)
        end

      elsif value.is_a? Hash
        target_class = instance.send("build_#{key}").class
        instance.send(:"#{key}=", hash_to_resource(klass: target_class, data: value))
      else
        instance.send(:"#{key}=", value)
      end
    end

    instance
  end
end
