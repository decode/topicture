class Topic < ActiveRecord::Base
  has_many :messages
  has_many :posts, :class_name => 'Message', :conditions => 'messages.follow_id is null', :dependent => :destroy

  belongs_to :parent_topic, :class_name => 'Topic', :foreign_key => 'parent_id'
  has_many :sub_topics, :class_name => 'Topic', :foreign_key => 'parent_id', :dependent => :destroy

end
