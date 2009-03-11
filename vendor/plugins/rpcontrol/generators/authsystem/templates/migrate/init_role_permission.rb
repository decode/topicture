class InitRolePermission < ActiveRecord::Migration
  def self.up
    say 'create admin role ...'
    role = Role.new
    role.name = "admin"
    role.description = "role for admin"
    role.save!

    say 'create admin user ...'
    user = User.new :login=> "admin", :password=>"admin", :password_confirmation=>"admin", :email=>"admin@site.org"
    user.roles << role
    user.save

    say 'create anonymous role ...'
    anonymous = Role.new :name=>"anonymous", :description=>"role for unregistered user"
    anonymous.save

    say 'create anonymous user ...'
    user = User.new :login=> "anonymous", :password=>"1234567", :password_confirmation=>"1234567", :email=>"anonymous@site.org"
    user.roles << anonymous
    user.save

    say 'fetch all controller and action to permission db ...'
    Permission.synchronize_resource
    Permission.find( :all ).each do |p|
      p.roles << role
      p.save
    end

    say 'assign base permission to anonymous role'
    base = Permission.find :first, :conditions => { :perm_resource=>"usersessions", :perm_type=>"C" }
    base.roles << anonymous
    base.save
    base = Permission.find :first, :conditions => { :perm_resource=>"users/new", :perm_type=>"CA" }
    base.roles << anonymous
    base.save
    base = Permission.find :first, :conditions => { :perm_resource=>"users/show", :perm_type=>"CA" }
    base.roles << anonymous
    base.save
    base = Permission.find :first, :conditions => { :perm_resource=>"users/edit", :perm_type=>"CA" }
    base.roles << anonymous
    base.save
    base = Permission.find :first, :conditions => { :perm_resource=>"users/index", :perm_type=>"CA" }
    base.roles << anonymous
    base.save
    base = Permission.find :first, :conditions => { :perm_resource=>"firstpage", :perm_type=>"C" }
    base.roles << anonymous
    base.save


    say 'create regular permission for anonymous (also admin)'
    base = Permission.new :name=>"all index", :perm_resource=>"index", :perm_type=>"A" 
    base.roles << anonymous
    base.roles << role
    base.save
    base = Permission.new :name=>"all show", :perm_resource=>"show", :perm_type=>"A" 
    base.roles << anonymous
    base.roles << role
    base.save
    base = Permission.new :name=>"all table", :perm_resource=>"table", :perm_type=>"A" 
    base.roles << anonymous
    base.roles << role
    base.save
    base = Permission.new :name=>"all list", :perm_resource=>"list", :perm_type=>"A" 
    base.roles << anonymous
    base.roles << role
    base.save
    base = Permission.new :name=>"all show_search", :perm_resource=>"show_search", :perm_type=>"A" 
    base.roles << anonymous
    base.roles << role
    base.save
    base = Permission.new :name=>"all row", :perm_resource=>"row", :perm_type=>"A" 
    base.roles << anonymous
    base.roles << role
    base.save
    base = Permission.new :name=>"all nasted", :perm_resource=>"nasted", :perm_type=>"A" 
    base.roles << anonymous
    base.roles << role
    base.save
  end

  def self.down
  end
end
