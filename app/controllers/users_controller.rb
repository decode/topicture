class UsersController < ApplicationController
  layout "base"
  include AccessFilter

  active_scaffold
  ActiveScaffold.set_defaults do |config|
    config.ignore_columns.add [:password_salt, :crypted_password, :persistence_token]
  end

  controller_accessor :create, :delete, :update, :show, :index

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]

  def new
    @user = User.new

    respond_to do |format|
      format.html
      format.xml { render :xml => @user }
    end
  end

  def create
    @user = User.new(params[:user])
    #@user.login.downcase!
    if @user.save
      flash[:notice] = "Account registered!"
      #redirect_back_or_default account_url
      redirect_back_or_default users_url
    else
      render :action => :new
    end
  end

  def show
    #@user = @current_user
    @user = User.find(params[:id])

    respond_to do |format|
      format.html
      format.xml { render :xml => @user }
    end
  end

  def edit
    #@user = @current_user
    @user = Message.find(params[:id])
  end

  def update
    #@user = @current_user # makes our views "cleaner" and more consistent
    @user = User.find(params[:id])
    #@user.login.downcase!
    respond_to do |format|
      params[:user][:login].downcase!
      if @user.update_attributes(params[:user])
        flash[:notice] = "Account updated!"
        #redirect_to account_url
        #redirect_to users_url
        format.html { redirect_to(@user) }
        format.xml { head :ok }
      else
        #render :action => :edit
        format.html { render :action => "edit" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Display user's main page
  def view
    @user = User.find_by_login(params[:name])
    session[:target_user_id] = @user.id
    if @user.nil?
      #redirect_to :controller => "users"        
    end
  end

  def panel
    #@user = User.find_by_login(params[:name])
    @user = current_user
  end

  def modify
    if params[:mark_delete] 
      Message.mark_delete(params[:messages])
    end
    if params[:mark_read]
      Message.mark_read(params[:messages])
      flash[:notice] = "Message status changed"
    end
    @user = current_user
    render :partial => "message_list", :object => current_user
  end
  
end
