class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.references :user
      t.references :message
      t.references :gallary
      t.timestamps
    end
  end

  def self.down
    drop_table :attachments
  end
end
