# -*- coding: utf-8 -*-
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  #include AccessFilter
  before_filter :init_locale

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '7998ac65c12e99368191cc95de1419c4'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, alsl fields with names like "password").
  # filter_parameter_logging :password
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user

  #ActiveScaffold.set_defaults do |config|
  #  config.security.default_permission = false
  #end
  #ActiveScaffold.set_defaults do |config|
  #  config.security.current_user_method = :current_user
  #end

  # Return back or return default url
  def redirect_back_or_default(default)
    begin
      session[:return_to] ? redirect_to(session[:return_to]) : redirect_to(default) 
    rescue ActionController::RedirectBackError
      session[:return_to] = nil
      redirect_to(default)
    end
    session[:return_to] = nil
  end

  private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      #redirect_to account_url
      redirect_to users_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def init_locale
    I18n.locale = current_user.locale if current_user and !current_user.locale.nil?
    I18n.locale = session[:language] unless session[:language].nil?
  end
  
end
