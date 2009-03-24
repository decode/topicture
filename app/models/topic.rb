class Topic < ActiveRecord::Base
  has_many :messages

  belongs_to :parent_topic, :class_name => 'Topic', :foreign_key => 'parent_id'
  has_many :sub_topics, :class_name => 'Topic', :foreign_key => 'parent_id'
end
