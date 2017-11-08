# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class DatasetConnection
  include ActiveModel::Model

  attr_accessor :host, :port, :sid, :user, :password, :uri

  # Connection type: jdbc or uri
  attr_writer :type

  def type
    @type || 'JDBC'
  end

  def jdbc?
    type == 'JDBC'
  end

  def uri?
    type == 'URI'
  end
end
