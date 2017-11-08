# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class SearchFilterDecorator
  def initialize(collection, options = {}, &block)
    @collection = collection
    @hidden_class = options.fetch(:hidden_class, 'overflow-filter')
    @displayed = options.fetch(:displayed, 5)
    @method = options.fetch(:method, :id)
    @renderables = []
    @block = block
  end

  def renderables
    count = 0
    @collection.each do |item|
      checked = @block.call(item) == true if @block
      @renderables << OpenStruct.new(
        item: item,
        checked: checked,
        html_class: (count < @displayed || checked) ? '' : @hidden_class
      )
      count += 1
    end
    @renderables
  end

  def show_more?
    @renderables.reject(&:checked).count > @displayed
  end
end
