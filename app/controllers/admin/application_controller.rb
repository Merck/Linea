# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_filters.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_filter :authenticate_admin_user
    helper MarkdownHelper

    def index
      search_term = params[:search].to_s.strip
      resources = Administrate::Search.new(resource_resolver, search_term).run
      resources = order.apply(resources)
      resources = resources.paginate(page: params[:page])
      page = Administrate::Page::Collection.new(dashboard, order: order)

      render locals: {
        resources: resources.paginate(page: params[:page]),
        search_term: search_term,
        page: page
      }
    end

    def authenticate_admin_user
      redirect_to log_in_path unless admin_user
    end

    def records_per_page
      params[:per_page] || 20
    end

    private

    def admin_user
      return false unless current_user
      current_user.is_admin?
    end

    def current_user
      @current_user ||= User.find_by_id(session[:user_id])
    end
  end
end
