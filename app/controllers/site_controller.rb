class SiteController < ApplicationController
  layout 'site'

  def index
    @news = Message.find :all, :conditions => 'message_type = news', :order => 'created_at DESC', :limit => 5
    @topic_news = Message.find :all, :conditions => 'topic_id != nil', :order => 'created_at DESC', :limit => 20
    @blog_news = Message.find :all, :conditions => '', :order => 'created_at DESC', :limit => 20
  end
end
