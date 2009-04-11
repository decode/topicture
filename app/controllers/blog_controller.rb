class BlogController < ApplicationController
  layout 'site'

  def index
    session[:return_to] = "/blog/index"
    session[:view_type] = 'blog'
    @new_blogs = Message.find :all, :conditions => "message_type = 'blog'", :order => 'created_at DESC', :limit => 10
    @new_registers = User.find :all, :conditions => "login != 'admin' and login != 'anonymous'", :order => 'created_at DESC', :limit => 5
  end

  def post
    session[:return_to] = "/blog/manage"
    session[:message_type] = 'blog'
    session[:topic_id] = nil
    session[:target_message_id] = nil
    @article = Message.new  
  end
  
  # manage blog articles and comment, include settings page
  def manage
    session[:return_to] = "/blog/manage"
    begin
      @articles = Message.paginate :all, :conditions => ['user_id=? and follow_id is null', current_user.id], :order => 'created_at DESC', :page => params[:page]
    rescue
      redirect_to :controller => "site"
    end
  end
  

end
