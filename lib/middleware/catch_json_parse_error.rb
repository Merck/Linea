# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class CatchJsonParseErrors
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue ActionDispatch::ParamsParser::ParseError => exception
    content_type_is_json?(env) ? build_response(exception) : raise(exception)
  end

  private

  def content_type_is_json?(env)
    env['CONTENT_TYPE'] =~ /application\/json/ || env['CONTENT_TYPE'] =~ /application\/vnd.api\+json/
  end

  def error_message(exception)
    "Payload data is not valid JSON. Error message: #{exception}"
  end

  def build_response(exception)
    [400, { "Content-Type" => "application/json" }, [{ error: sanitize_message(error_message(exception)) }.to_json]]
  end

  def sanitize_message(msg)
    # filter out password
    msg.gsub(/(['"]*password['" ]*[:]?[ ]*)(['"])[^'"]*(['"]*)/, '\\1\\2*FILTERED*\\3')
  end
end
