# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'application_responder'

class ApplicationController < ActionController::Base
  include Pundit

  before_action :store_location
  before_filter :set_controller_and_action, except: [:start, :routing_error]
  before_action :set_raven_context
  #rescue_from Exception, with: :error_occurred unless Rails.env == 'development'

  include ControllerExtensions::MustAcceptTermsOfUse
  helper_method :app_version
  helper_method :current_user, :logged_in?

  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  rescue_from ActiveRecord::RecordNotFound do |exception|
    respond_to do |format|
      format.html do
        redirect_to '/' + params['controller'],
                    notice: params['controller'].singularize.capitalize + ' not found'
      end
      format.json { render json: exception.message, status: :not_found }
    end
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    template = params['action'] == 'create' ? :new : :edit

    respond_to do |format|
      format.html { render template }
      format.json { render json: exception.message, status: :unprocessable_entity }
    end
  end

  rescue_from ActionController::InvalidAuthenticityToken do
    flash[:alert] = "Your session has expired. Please sign in again."
    redirect_back_or_default
  end

  def error_occurred(exception)
    @exception = exception
    render 'errors/exception'
  end

  def app_version
    revision = AppName::REVISION
    ENV.fetch('APPLICATION_VERSION') + ' (#sha1:' + revision + ')'
  end

  def routing_error
    render_404
  end

  def store_location
    session[:return_to] = (request.get?) ? request.path : request.referer
  end

  def clear_stored_location
    session[:return_to] = nil
  end

  def redirect_back_or_default(default = root_url, options = {})
    redirect_to(session.delete(:return_to) || default, options)
  end
  alias redirect_back_url redirect_back_or_default

  private

  def set_raven_context
    return unless logged_in?
    Raven.user_context({
      user_id: current_user.id,
      user_username: current_user.username
    })
  end

  def render_404
    render file: 'shared/404', formats: [:html], layout: false, status: 404
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    message = t("#{policy_name}.#{exception.query}", scope: 'pundit', default: :default)

    respond_to do |format|
      format.html do
        redirect_to(request.referrer || root_path)
        flash[:danger] = message
      end
      format.json { render json: { message: message }, status: :unauthorized }
    end
  end

  protected

  def set_controller_and_action
    @__controller = params[:controller]
    @__action = params[:action]
  end

  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate_user
    logged_in? || redirect_to(log_in_path)
  end

  def authenticate_admin
    return unless authenticate_user
    if current_user && current_user.is_admin?
      true
    else
      flash[:info] = 'This area is only available for administrators'
      redirect_to root_url
    end
  end
end
