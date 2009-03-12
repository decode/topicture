class User < ActiveRecord::Base
  acts_as_authentic
  acts_as_user

  has_many :sent_messages, :class_name => "Message", :foreign_key => "user_id"

  # Message relation
  has_many :messagebox, :foreign_key => "user_id"
  has_many :received_messages, :through => :messagebox, :source => :message
  has_many :unread_messages, :through => :messagebox, :source => :message, :conditions => "workflow_state = 'unread'"
  has_many :read_messages, :through => :messagebox, :source => :message, :conditions => "workflow_state = 'open'"
  has_many :deleted_messages, :through => :messagebox, :source => :message, :conditions => "workflow_state = 'suspend'"

  # Friend relation
  has_many :friendship, :dependent => :destroy
  has_many :friends, :through => :friendship, :conditions => "workflow_state = 'accept'"
  has_many :blocks_users, :through => :friendship, :conditions => "workflow_state = 'block'"
  has_many :strangers, :through => :friendship, :conditions => "workflow_state = 'request'"
  has_many :refused_users, :through => :friendship, :conditions => "workflow_state = 'refuse'"
  has_many :relations, :through => :friendship

  def to_label
    login
  end

end
