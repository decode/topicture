class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  layout 'site'

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:success] = t('system.login_success')
      redirect_back_or_default "/site"
    else
      flash[:error] = t('system.login_failed')
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:success] = t('system.logout_success')
    redirect_back_or_default "/site" #new_user_session_url
  end
end
