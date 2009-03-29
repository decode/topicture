class BlogController < ApplicationController
  layout 'site'

  def index
    @new_blogs = Message.find :all, :conditions => "message_type = 'blog'", :order => 'created_at DESC', :limit => 10
    @new_registers = User.find :all, :conditions => "login != 'admin' and login != 'anonymous'", :order => 'created_at DESC', :limit => 5
  end

  def post
    #session[:return_to] = "/user/#{current_user.login}"
    @article = Message.new  
  end
  
  
end
