class MessagesController < ApplicationController
  
  layout "site"
  include AccessFilter

  active_scaffold
  active_scaffold :messages do | config |
    config.actions.exclude :create, :search
    config.columns = [:title, :body, :created_at, :updated_at]
  end
  
  def conditions_for_collection
    #['login != ?', 'admin'] unless current_user.has_role? 'admin'
    return '' if session[:message_type].nil?
    ['message_type = ?', session[:message_type]]
  end

  # GET /messages
  # GET /messages.xml
  def index
    @messages = Message.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    @message = Message.find(params[:id])
    @message.view_count = @message.view_count + 1
    @message.save
    session[:target_user_id] = @message.user.id unless @message.user.nil?
    session[:return_to] = message_path(@message)
    if session[:view_style] != 'blog'
      @reply = Message.new
      # prevent display single message in topic mode
      unless @message.follow_message.nil?# || session[:view_style] == 'single'
        @message = @message.follow_message
      end
      @replies = Message.paginate :conditions => ['follow_id=?', @message.id], :order => 'created_at DESC', :page => params[:page], :per_page => 15
      respond_to do |format|
        format.html {# show.html.erb {
          render :layout => 'site'
        }
        format.xml  { render :xml => @message }
      end
    else
      @article = @message
      @user = @message.user

      # Display for sidebar
      @articles = @user.articles
      source_ids = @articles.collect { |m| m.id }
      @latest_comments = Message.find :all, :conditions => ["follow_id='?' and user_id!=?", source_ids, @user.id], :order => 'created_at DESC', :limit => 15

      @comment = Message.new
      respond_to do |format|
        format.html {render :action => 'blog_view', :id => params[:id], :layout => 'blog' }
        format.xml { render :xml => @message }
      end
    end
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    @message = Message.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/1/edit
  def edit
    if session[:view_style] != 'blog'
      @message = Message.find(params[:id])
    else
      @article = Message.find(params[:id])
      session[:target_user_id] = @article.user.id
      render :action => 'blog_edit', :layout => 'blog'
    end
  end

  # POST /messages
  # POST /messages.xml
  def create
    @message = Message.new(params[:message])
    @message.message_type = session[:message_type]

    # Add reply message
    target_id = session[:target_message_id]
    unless target_id.nil?
      #@message.follow_id = target_id 
      @message.message_type ||= Message.find_by_id(target_id).message_type
      session[:target_message_id] = nil
    end

    # Record message sender's id
    if current_user.nil?
      @msesage.user = User.find_by_login('anonymous')
    else
      @message.user_id = current_user.id
    end

    # Record message receiver's id
    blocked = false
    unless session[:target_user_id] == current_user.id
      receiver = User.find_by_id(session[:target_user_id]) unless session[:target_user_id].nil?
      unless receiver.nil?
        blocked = receiver.blocked_users.include?(current_user)
        if blocked
          flash[:notice] = "You are blocked"
        else
          @message.receivers << receiver
        end
      end
    end
    #session[:target_user_id] = nil
 
    # Add topic reference
    unless session[:topic_id].nil?
      @message.topic_id = session[:topic_id].to_i
      @message.message_type ||= 'topic'
    end

    # If not specified type, use default message_type: both topic and blog
    @message.message_type ||= 'topic|blog'

    respond_to do |format|
      if @message.save and blocked == false
        flash[:success] = 'Message was successfully created.'
        format.html do 
          redirect_back_or_default session[:return_to]
        end
        format.xml { render :xml => @message, :status => :created, :location => @message }
      else
        format.html do 
          if blocked
            redirect_back_or_default "/user/#{receiver.login}"
          else
            flash[:error] = "Message not saved"
            render :action => "new" 
          end
        end
        format.xml { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
    @message = Message.find(params[:id])
    params[:message][:last_edit_id] = current_user.id
    respond_to do |format|
      if @message.update_attributes(params[:message])
        flash[:success] = 'Message was successfully updated.'
        format.html { redirect_to(@message) }
        format.xml  { head :ok }
      else
        flash[:error] = 'Message has not updated'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_back_or_default session[:return_to] }
      format.xml  { head :ok }
    end
  end

  # Reply a existing message
  def reply
    unless params[:id].nil?
      session[:target_message_id] = params[:id]
      session[:return_to] = message_path(params[:id])
      redirect_to :action => "new"
    else
      redirect_to :action => "show"
    end
  end

  def mark_read
    Message.handle(current_user, [*params[:id]]) { |m| m.read }
    flash[:success] = "Message status changed"# if msg_box.state == "open"
    redirect_back_or_default :back #messages_url
  end
  
  def view
    @message = Message.find params[:id] 
  end
  
  def blog_view
  end

  # Quote user's post content
  def quote
    source = Message.find params[:id]   
    @message = Message.new
    @message.body = "Quote content: " + source.body
    render :action => 'new'
  end
  
end
