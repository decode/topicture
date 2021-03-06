class UsersController < ApplicationController
  layout "site"

  #include AccessFilter

  active_scaffold
  ActiveScaffold.set_defaults do |config|
    config.ignore_columns.add [:password_salt, :crypted_password, :persistence_token, :unread_messages, :read_messages, :deleted_messages, :request_messages, :refuse_messages]
    #config.actions.exclude :nested
  end

  active_scaffold :users do | config |
    config.columns = [:login, :email, :login_count, :last_login_at]
    #config.columns[:messages].includes = [:messageboxes]
    #config.columns[:last_transaction_date].sort_by :sql => "user_transactions.created_at"
  end

  def conditions_for_collection
    ['login != ?', 'admin'] unless current_user.has_role? 'admin'
  end

  #controller_accessor :create, :delete, :update, :show, :index

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
    @user.roles << Role.find_by_name('normal')
    #@user.login.downcase!
    if @user.save
      flash[:success] = t('account.registered_success')
      #redirect_back_or_default account_url
      current_user = @user
      redirect_back_or_default "/user/#{@user.login}"
    else
      flash[:error] = t('account.register_failed')
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
    @user = (User.find(params[:id]) if params[:id]) || current_user
  end

  def update
    #@user = @current_user # makes our views "cleaner" and more consistent
    @user = User.find(params[:id])
    #@user.login.downcase!
    #@user.roles << Role.find(params[:roles])
    @user.save
    respond_to do |format|
      params[:user][:login].downcase!
      if @user.update_attributes(params[:user])
        flash[:success] = t('account.update_success')
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
  def info
    session[:view_style] = 'blog'
    session[:message_type] = 'blog'
    @user = User.find_by_login(params[:name] || current_user.login)
    @articles = @user.articles
    source_ids = @articles.collect { |m| m.id }
    #@latest_comments = Message.find :all, :conditions => ["follow_id='?' and user_id!=?", source_ids, @user.id], :order => 'created_at DESC', :limit => 15
    @latest_comments = Message.find :all, :conditions => {:follow_id=>source_ids}, :order => 'created_at DESC', :limit => 15

    session[:target_user_id] = @user.id
    if @user.nil?
      #redirect_to :controller => "users"
    end
    render :layout => 'blog'
  end

  # The page of user manage their settings
  def panel
    #@user = User.find_by_login(params[:name])
    session[:return_to] = "/user/#{current_user.login}/panel"
    @user = current_user
    render :action => 'panel', :layout => 'site'
  end

  # Show message list
  def message
    session[:view_style] = "single"
    session[:message_type] = "message"
    session[:return_to] = "/users/message"
    if current_user
      @user = current_user
      @received_messages = @user.received_messages.paginate :page => params[:page], :per_page => 10, :order => 'created_at DESC'#Message.paginate :page => params[:page]||1, :conditions => "messageboxes.workflow_state = 'unread' or messageboxes.workflow_state = 'open'", :order => 'created_at DESC'
      @unread_messages = @user.unread_messages.paginate :page => params[:page], :per_page => 10, :order => 'created_at DESC'
      @read_messages = @user.read_messages.paginate :page => params[:page], :per_page => 10, :order => 'created_at DESC'#Message.paginate :page => params[:page]||1, :conditions => "messageboxes.workflow_state = 'unread' or messageboxes.workflow_state = 'open'", :order => 'created_at DESC'
      @sent_messages = @user.sent_messages.paginate :page => params[:page], :per_page => 10, :order => 'created_at DESC'#, :conditions => "messageboxes.workflow_state = 'unread' or messageboxes.workflow_state = 'unread'", :order => 'created_at DESC'
    end
  end

  def message_modify
    if params[:mark_delete]
      Message.handle(current_user, params[:messages]) { |msg| msg.msg_delete }
      flash[:success] = t('manage.message_has_been_delete')
    end
    if params[:move]
      Message.handle(current_user, params[:messages]) { |msg| msg.move }
      flash[:success] = t('manage.message_status_changed')
    end
    if params[:mark_read]
      Message.handle(current_user, params[:messages]) { |msg| msg.read }
      flash[:success] = t('manage.message_status_changed')
    end
    #render :partial => "message_list", :object => current_user
    respond_to do |format|
      format.html { redirect_to '/users/message' }
      format.js do
        render :update do |page|
          page.replace_html 'message_list', :partial => 'message_list', :object => @user
        end
      end
    end
  end

  def trash
    @user = current_user
  end

  def trash_modify
    if params[:mark_delete]
      Message.handle(current_user, params[:messages]) { |msg| msg.delete_forever }
      flash[:success] = t('manage.message_has_been_delete')
    end
    if params[:mark_read]
      Message.handle(current_user, params[:messages]) { |msg| msg.read }
      flash[:success] = t('manage.message_status_changed')
    end
    if params[:move]
      Message.handle(current_user, params[:messages]) { |msg| msg.move }
      flash[:success] = t('manage.message_status_changed')
    end
    #render :partial => "message_list", :object => current_user
    respond_to do |format|
      format.html { redirect_to '/users/trash' }
      format.js do
        render :update do |page|
          page.replace_html 'trash_message_list', :partial => 'trash_message_list', :object => @user
        end
      end
    end
  end

  def friend
    @user = current_user
  end

  def friend_modify
    @user = current_user
    if params[:refuse]
      @user.handle(params[:request_users]) { |user| user.refuse }
      @user.handle(params[:friend_list]) { |user| user.refuse }
    end
    if params[:accept]
      @user.handle(params[:request_users]) { |user| user.approve }
      @user.handle(params[:friend_users]) { |user| user.approve }
    end
    if params[:block]
      @user.handle(params[:request_users]) { |user| user.block}
      @user.handle(params[:friend_users]) { |user| user.block}
    end
    if params[:delete]
      @user.handle(params[:request_users]) { |user| user.delete }
      @user.handle(params[:friend_users]) { |user| user.delete }
    end
    #render :update do |page|
    #  page.replace_html 'friend_list', :partial => 'friend_list', :object => @user
    #end
    respond_to do |format|
      format.html { redirect_to '/users/friend' }
      format.js do
        render :update do |page|
          page.replace_html 'friend_list', :partial => 'friend_list', :object => @user
          page.replace_html 'request_list', :partial => 'friend_list', :object => @user
        end
      end
    end
  end

  # Display a add friend box to input messages
  def invite
    session[:target_user_id] = params[:id]
  end

  def invite_request
    @source_user = current_user
    @dest_user = User.find_by_id(session[:target_user_id])
    if @source_user.friends.include? @dest_user
      flash[:notice] = t('manage.already_friend')
    else
      if @source_user.blocked_by?(@dest_user)
        flash[:error] = t('manage.has_been_blocked')
      else
        @dest_user.strangers << @source_user
        @dest_user.save
        @source_user.strangers << @dest_user
        @dest_user.save

        # Create User Message to the user being requested
        message = Message.new(params[:message])
        message.receivers << @dest_user
        message.user = @source_user
        message.save
        Message.handle(@dest_user, [*message.id]) { |m| m.change_to_request }

        # Create System Message to inform user
        message = Message.new(:title => "User Request", :body => "User:#{@source_user.login} has add you as friend")
        message.receivers << @dest_user
        message.save
        flash[:success] = t('manage.request_has_been_sent')
      end
    end
    redirect_back_or_default "/user/#{@dest_user.login}"
  end

  # Show block user list
  def block
    @user = current_user
    render :action => 'block', :layout => 'site'
  end

  def unblock
    @user = current_user
    unblocked_user = User.find_by_id params[:id]
    @user.handle([*unblocked_user.id]) { |u| u.approve }
    @user.save
    redirect_to :action => "block"
  end

  def send_message
    if params[:id]
      session[:target_user_id] = params[:id]
    end
    session[:message_type] = 'message'
    redirect_to :controller => "messages", :action => "new"
  end

  def gallary
    session[:return_to] = "/users/gallary"
    @gallaries = Gallary.paginate(:conditions => ['user_id=?',current_user.id], :order => 'updated_at DESC',:page=>params[:page])
    render :action => 'gallary', :layout => 'site'
  rescue
    redirect_to :controller => "site"
  end
end
