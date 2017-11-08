# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
module Api
  module V1
    class ApiController < JSONAPI::ResourceController
      protect_from_forgery with: :null_session
      skip_before_action :verify_authenticity_token

      rescue_from Exception do |e|
        render nothing: true, status: 400, json: { message: e.message }
      end

      def forbidden_request
        render json: {error: 'Forbidden'}, status: 403
      end

      def bad_request
        render json: {error: 'Bad request'}, status: :bad_request
      end
    end
  end
end
