# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
module Api
  module V1
    class RestrictedApiController < ApiController
      before_filter :check_api_key
      respond_to :json

      attr_reader :user_by_api

      private

      def check_api_key
        @user_by_api = ApiUser.find_by_api_key(request.headers['HTTP_AUTHORIZATION'])
        @user_by_api = nil if @user_by_api && @user_by_api.timeouted?
        head :unauthorized and return unless @user_by_api
        @user_by_api.touch
      end
    end
  end
end
