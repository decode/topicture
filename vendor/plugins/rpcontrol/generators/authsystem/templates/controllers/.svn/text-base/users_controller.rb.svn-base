class UsersController < ApplicationController
  layout "base"
  active_scaffold
  ActiveScaffold.set_defaults do |config|
    config.ignore_columns.add [:password_salt, :crypted_password, :persistence_token]
  end

  controller_accessor :create, :delete, :update, :show, :index

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Account registered!"
      #redirect_back_or_default account_url
      redirect_back_or_default users_url
    else
      render :action => :new
    end
  end

  def show
    @user = @current_user
  end

  def edit
    @user = @current_user
  end

  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      #redirect_to account_url
      redirect_to users_url
    else
      render :action => :edit
    end
  end
end
