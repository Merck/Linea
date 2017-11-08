# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class SinatraShim
  def initialize(sinatra_class:, port:)
    @sinatra_class = sinatra_class
    @port = port
    @sinatra_started = false
    @check_interval_s = 0.1
    @timeout_s = 10
  end

  def start!
    Thread.new do
      Thin::Logging.silent = true
      Rack::Handler::Thin.run @sinatra_class, Port: @port do |server|
        @sinatra_started = true
        server.start!
      end
    end
    waiting_s = 0
    until @sinatra_started
      sleep @check_interval_s
      waiting_s += @check_interval_s
      if waiting_s > @timeout_s
        fail("Cannot start sinatra shim service '#{@sinatra_class}' - timeout in #{@timeout_s}")
      end
    end
    STDERR.puts "Sinatra Shim #{@sinatra_class} started on port #{@port}"
  end
end
