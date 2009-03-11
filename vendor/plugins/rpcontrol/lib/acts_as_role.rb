require 'activerecord'
module ActsAsRole
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_as_role
      has_and_belongs_to_many :permissions
      has_and_belongs_to_many :users
    end
  end
end

ActiveRecord::Base.send(:include, ActsAsRole)
