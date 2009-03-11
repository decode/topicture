class User < ActiveRecord::Base
  acts_as_authentic
  acts_as_user

  has_many :sent_messages, :class_name => "Message", :foreign_key => "user_id"

  has_many :messagebox, :foreign_key => "user_id"
  has_many :received_messages, :through => :messagebox, :source => :message

  has_many :unread_messages, :through => :messagebox, :source => :message, :conditions => "workflow_state = 'unread'"
  has_many :read_messages, :through => :messagebox, :source => :message, :conditions => "workflow_state = 'open'"
  has_many :deleted_messages, :through => :messagebox, :source => :message, :conditions => "workflow_state = 'suspend'"

  def to_label
    login
  end

end
