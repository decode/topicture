class AdminController < ApplicationController
  active_scaffold :users
  active_scaffold :messages
  active_scaffold :topics

  def index
   
  end
  
  def manage_user
  end
  
  def manage_post
    session[:manage_type] = 'topic'
  end

  def manage_blog
    session[:manage_type] = 'blog'
  end

  def manage_message
    session[:manage_type] = 'message'
  end
  
end
