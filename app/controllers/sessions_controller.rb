# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class SessionsController < ApplicationController
  skip_before_action :store_location
  skip_before_filter :authenticate_user, except: [:destroy, :impersonate, :cancel_impersonation]
  skip_before_filter :accept_terms_of_use, [:destroy]

  def logout
    session[:user_id] = nil
    redirect_to root_url
  end

  def login
  end

  def create
    user = User.authenticate(env['omniauth.auth'])

    session[:user_id] = user.id if user

    #puts auth.provider
    #puts auth.uid
    #puts auth.info.name
    #puts auth.credentials.token
    #puts Time.at(auth.credentials.expires_at)

    redirect_back_or_default
  end

  def destroy
    logout
    clear_stored_location
  end

  def login_attempt
    if params[:username].blank? || params[:password].blank?
      flash[:warning] = 'Missing username and/or password'
      redirect_to(log_in_path)
    else
      if user = AuthenticationService.authenticated_user(params[:username].to_s.downcase, params[:password])
        session[:user_id] = user.id
        redirect_back_or_default
      else
        flash[:warning] = 'Invalid username and/or password'
        redirect_to(log_in_path)
      end
    end
  end

  def impersonate
    user_id = params[:user_id]

    if authenticate_admin # Only admins can impersonate
      session[:old_user_id] = current_user.id
      session[:user_id] = user_id
    else
      flash[:warning] = 'Only admins can impersonate'
    end

    redirect_to(root_url)
  end

  def cancel_impersonation
    session[:user_id] = session[:old_user_id]
    session.delete(:old_user_id)

    redirect_to(users_url)
  end
=begin
  def configured_for_kerberos
    if response.status.to_s == '401'
      browser = Browser.new(:ua => request.env['HTTP_USER_AGENT'], :accept_language => "en-us")
      if browser.mac?
        if browser.chrome? or browser.firefox?
          return false
        end
      end
    else
      true
    end
  end
=end
end
