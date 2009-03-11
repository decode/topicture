require 'activerecord'

module ActsAsUser
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_as_user
      class_eval <<-"end_eval", __FILE__, __LINE__

      #delegate :permissions, :to => :role

      has_and_belongs_to_many :roles

      def has_role?(*roles)
        self.roles.find(:all, :conditions=>{:name => roles.to_a}).size > 0
      end

      def add_role(role)
        return if has_role?(role)
        self.roles << Role.find_by_login(role.name)
      end

      def has_permission?(*permissions)
        isA = false
        #perms = self.roles.collect{|item| item.permissions }
        perms = Array.new
        self.roles.each do |r|
          r.permissions.each {|p| perms << p.name}
        end
        permissions.each do |per_name|
          perms.each do |p| 
            if p == per_name
              isA = true 
              break
            end
          end
        end
        return isA
      end
      end_eval
    end

  end

end

ActiveRecord::Base.send(:include, ActsAsUser)
