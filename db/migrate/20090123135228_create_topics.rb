class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.string :name
      t.integer :parent_id
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :topics
  end
end
