# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'uri'

module DatasetsHelper
  # if the value is URL, render as active URL
  # if value contains \n, render it with <br/>
  def render_attribute_value(attribute)
    text = urlize(attribute.value)
    text.gsub(/\n/, '<br/>').html_safe
  end

  def urlize(text)
    urls = URI.extract(text, ['http', 'https'])
    urls.each do |url|
      newurl = truncate(url, length: 50).gsub(/^http[s]?:\/\//, '')
      text.gsub!(url, "<a href=\"#{url}\" target=\"_blank\">#{newurl}</a>")
    end
    text
  end
end
