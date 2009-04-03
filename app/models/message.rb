class Message < ActiveRecord::Base
  belongs_to :topic
  belongs_to :follow_message, :class_name => "Message", :foreign_key => "follow_id"
  has_many :follow_messages, :class_name => "Message", :order => 'created_at ASC', :foreign_key => "follow_id"

  belongs_to :user, :foreign_key => :user_id

  has_many :messagebox, :foreign_key => "message_id"
  has_many :receivers, :through => :messagebox, :source => :user
  
  belongs_to :last_edit_user, :class_name => "User", :foreign_key => "last_edit_id"

  def self.handle(messages)
    messages.each do |msg_id|
      msg = Messagebox.find_by_message_id(msg_id)
      yield(msg)
      msg.save
    end unless messages.nil?
  end
  
  def self.mark_delete(messages)
    messages.each do |msg_id|
      msg = Messagebox.find_by_message_id(msg_id)   
      msg.msg_delete
      msg.save
    end
  end

  def self.mark_read(messages)
    messages.each do |msg_id|
      msg = Messagebox.find_by_message_id(msg_id)
      msg.read
      msg.save
    end
  end

  def self.move(messages)
    messages.each do |msg_id|
      msg = Messagebox.find_by_message_id(msg_id)
      msg.move
      msg.save
    end
  end

  # Change message type to add friend request
  def change_to_request
    msg = Messagebox.find_by_message_id(self.id)
    msg.change_to_request
    msg.save
  end

end
