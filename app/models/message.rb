class Message < ActiveRecord::Base
  belongs_to :topic
  belongs_to :follow_message, :class_name => "Message", :foreign_key => "follow_id"
  has_many :follow_messages, :class_name => "Message", :foreign_key => "follow_id"

  belongs_to :user, :foreign_key => :user_id

  has_many :messagebox, :foreign_key => "message_id"
  has_many :receivers, :through => :messagebox, :source => :user


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
    end
  end

end
