class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.string :name, :null => false
      t.string :description
      #t.string :controller_name, :controller_action
      t.string :perm_type, :perm_resource
      t.timestamps
    end

    create_table :permissions_roles, :id => false do |t|
      t.integer :permission_id
      t.integer :role_id
    end
  end

  def self.down
    drop_table :permissions
    drop_table :permissions_roles
  end
end
