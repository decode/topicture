class SiteController < ApplicationController
  def index
    session[:return_to] = '/site'
    @news = Message.find :all, :conditions => "message_type = 'news'", :order => 'created_at DESC', :limit => 5
    @topic_news = Message.find :all, :conditions => "message_type = 'topic'", :order => 'created_at DESC', :limit => 10
    @blog_news = Message.find :all, :conditions => "message_type = 'blog'", :order => 'created_at DESC', :limit => 10
  end
end
