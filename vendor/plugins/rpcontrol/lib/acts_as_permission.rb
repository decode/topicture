require 'activerecord'
require 'find'

module ActsAsPermission
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_as_permission
      has_and_belongs_to_many :roles


      class_eval <<-"end_eval", __FILE__, __LINE__
    def self.synchronize_resource
      # Load all the controller files
      # ToDo: hunt sub-directories
      Find.find( RAILS_ROOT + '/app/controllers' ) do |file_name|
        load file_name if /_controller.rb$/ =~ file_name
      end

      Find.find( RAILS_ROOT + '/app/controllers' ) do |file_name|
        if File.basename(file_name)[0] == ?.
          Find.prune
        else
          if /_controller.rb$/ =~ file_name
            load file_name
          end
        end
      end

      # Find the actions in each of the controllers,
      # resulting in an array of strings named like "foo/bar"
      # representing the controller/action
      all_controllers = Array.new

      all_actions = Object.subclasses_of(ApplicationController)
      all_actions.collect! do |controller|
        methods = controller.public_instance_methods - controller.hidden_actions
        methods.collect do |method_name|
          #ignore methods ending with a ? and the 'l' method

          # if in normal block should uncomment below code
          #if /\\?$/ =~ method_name || "l" == method_name
          # if in class_eval block should uncomment below code
          if /\\?$/ =~ method_name || "l" == method_name
            nil
          else
            all_controllers << controller.name.gsub( /Controller$/, '' ).downcase.gsub(/::/, '/')
            controller.name.gsub( /Controller$/, '' ).downcase.gsub(/::/, '/') + '/' + method_name
          end
        end
      end.flatten!.compact!

      all_controllers.uniq!

      # Find all the 'action_path' columns currently in my table
      all_records = self.find :all
      known_actions = all_records.collect{ |permission| permission.perm_resource if permission.perm_type == "CA" }
      known_controllers = all_records.collect{ |permission| permission.perm_resource if permission.perm_type = "C" }

      # If controllers/actions exist that aren't in the db
      # then add new entries for them
      missing_from_db = all_actions - known_actions
      missing_from_db.each do |action_path|
        self.new( :name => action_path, :perm_type=>"CA", :perm_resource=>action_path ).save
      end

      # Save all new controller to permission
      missing_from_db = all_controllers - known_controllers
      missing_from_db.each do |controller_path|
        self.new( :name => controller_path, :perm_type=>"C", :perm_resource=>controller_path ).save
      end

      # Clear out any entries in the table that do not
      # correspond to an existing controller/action
      bogus_db_actions = known_actions - all_actions
      unless bogus_db_actions.empty?
        #Create a mapping of path->Act instance for quick deletion lookup
        records_by_action_path = { }
        all_records.each do |permission|
          records_by_action_path[ permission.perm_resource ] = permission
        end
        bogus_db_actions.each do |action_path|
          records_by_action_path[ action_path ].destroy
        end
      end

      bogus_db_controllers = known_controllers - all_controllers
      unless bogus_db_controllers.empty?
        #Create a mapping of path->Act instance for quick deletion lookup
        records_by_controller_path = { }
        all_records.each do |permission|
          records_by_controller_path[ permission.perm_resource ] = permission
        end
        bogus_db_controllers.each do |controller_path|
          records_by_controller_path[ controller_path ].destroy
        end
      end

    end

    # This method was taken from:
	# dev.rubyonrails.com/file/trunk/activesupport/lib/active_support/core_ext/object_and_class.rb
	# I removed the condition for finding '::' so that the sub directory classes would work
	def Object.subclasses_of(*superclasses)
      subclasses = []
      ObjectSpace.each_object(Class) do |k|
        next if (k.ancestors & superclasses).empty? || superclasses.include?(k) || subclasses.include?(k)
        subclasses << k
      end
      subclasses
	end

    end_eval
  end # acts_as_permission
end # module ClassMethods
end

ActiveRecord::Base.send(:include, ActsAsPermission)
