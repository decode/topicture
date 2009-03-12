class MessagesController < ApplicationController
  
  include AccessFilter

  layout "site"
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

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
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
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.xml
  def create
    @message = Message.new(params[:message])

    # Add reply message
    @message.follow_id = session[:target_message_id].to_i unless session[:target_message_id].nil?
    session[:target_message_id] = nil

    # Record message sender's id
    @message.user_id = current_user.id unless current_user.nil?
    @message.receivers << User.find_by_id(session[:target_user_id]) unless session[:target_user_id].nil?
    session[:target_user_id] = nil
 
    # Add topic reference
    @message.topic_id = session[:topic_id].to_i unless session[:topic_id].nil?
    
    respond_to do |format|
      if @message.save
        flash[:notice] = 'Message was successfully created.'
        #begin
        #  redirect_to :back
        #rescue ActionController::RedirectBackError
        #  redirect_to messages_url
        #end
        format.html do 
          redirect_back_or_default @message
        end
        #format.html { redirect_to(@message) }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        flash[:notice] = 'Message was successfully updated.'
        format.html { redirect_to(@message) }
        format.xml  { head :ok }
      else
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
      format.html { redirect_to(messages_url) }
      format.xml  { head :ok }
    end
  end

  # Reply a existing message
  def reply
    unless params[:id].nil?
      session[:target_message_id] = params[:id]
      session[:return_to] = messages_url
      redirect_to :action => "new"
    else
      redirect_to :action => "show"
    end
  end

  def mark_read
    msg_box = Messagebox.find_by_message_id(params[:id])
    msg_box.read
    flash[:notice] = "Message status changed" if msg_box.state == "open"
    redirect_back_or_default messages_url
  end

  def trash
    @user = current_user
  end
  
  
  
end
