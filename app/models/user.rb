class User < ActiveRecord::Base
  acts_as_authentic
  acts_as_user

  has_many :sent_messages, :class_name => "Message", :foreign_key => "user_id", :conditions => "message_type='message'", :order => "created_at DESC"
  has_many :articles, :class_name => "Message", :foreign_key => "user_id", :conditions => "follow_id is null", :order => "created_at DESC"

  # Message relation
  has_many :messagebox, :foreign_key => "user_id"
  has_many :received_messages, :through => :messagebox, :source => :message
  has_many :unread_messages, :through => :messagebox, :source => :message, :conditions => "messageboxes.workflow_state = 'unread'"
  has_many :read_messages, :through => :messagebox, :source => :message, :conditions => "messageboxes.workflow_state = 'open'"
  has_many :deleted_messages, :through => :messagebox, :source => :message, :conditions => "messageboxes.workflow_state = 'suspend'"
  has_many :request_messages, :through => :messagebox, :source => :message, :conditions => "messageboxes.workflow_state = 'request'"
  has_many :refused_messages, :through => :messagebox, :source => :message, :conditions => "messageboxes.workflow_state = 'refuse'"

  # Friend relation
  has_many :friendships, :dependent => :destroy
  has_many :friends, :through => :friendships, :conditions => "friendships.workflow_state = 'accept'", :source => :friend
  has_many :blocked_users, :through => :friendships, :conditions => "friendships.workflow_state = 'block'", :source => :friend
  has_many :strangers, :through => :friendships, :conditions => "friendships.workflow_state = 'request'", :source => :friend
  has_many :refused_users, :through => :friendships, :conditions => "friendships.workflow_state = 'refuse'", :source => :friend
  has_many :relations, :through => :friendships, :source => :friend
  
  has_many :last_edit_messages, :class_name => 'Message', :foreign_key => 'last_edit_id'

  has_many :attachments
  has_many :gallaries

  def to_label
    login
  end
=begin
  def self.handle(users)
    users.each do |user_id|
      user = Friendship.find_by_friend_id(user_id)
      yield(user)
      user.save
    end unless users.nil?
  end
=end
  def handle(users)
    users.each do |user_id|
      user = Friendship.find :first, :conditions => ["friend_id=? and user_id =?", user_id, self.id]
      yield(user)
      user.save
    end unless users.nil?
  end

  def blocked_by?(user)
    return false if user.nil?
    return user.blocked_users.include? self
  end
  
end
