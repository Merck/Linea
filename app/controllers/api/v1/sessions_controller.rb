# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
module Api
  module V1
    class SessionsController < ApiController
      respond_to :json

      # FIXME: disallow to create api_user automatically
      def create
        user = AuthenticationService.authenticated_user(params[:username].to_s.downcase, params[:password])
        head :unauthorized and return unless user
        #api_user = ApiUser.find_by_user_id(user.id)
        api_user = ApiUser.find_or_create_by(user_id: user.id) # for testing purposes
        api_user.regenerate_api_key
        render status: 200, json: { api_key: api_user.api_key}
      end
    end
  end
end
