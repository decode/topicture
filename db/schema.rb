# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090525092952) do

  create_table "attachments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "message_id"
    t.integer  "gallary_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "object_file_name"
    t.string   "object_content_type"
    t.integer  "object_file_size"
    t.datetime "object_updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id",        :null => false
    t.integer  "friend_id",      :null => false
    t.string   "workflow_state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gallaries", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "attachments_count"
    t.string   "password"
    t.boolean  "ispublic"
    t.boolean  "isfriend"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messageboxes", :force => true do |t|
    t.integer  "user_id",        :null => false
    t.integer  "message_id",     :null => false
    t.string   "workflow_state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.integer  "topic_id"
    t.integer  "user_id"
    t.string   "title",                          :null => false
    t.text     "body"
    t.integer  "follow_id"
    t.string   "message_type"
    t.string   "comment_user"
    t.string   "comment_email"
    t.string   "comment_website"
    t.integer  "last_edit_id"
    t.integer  "view_count",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.string   "name",          :null => false
    t.string   "description"
    t.string   "perm_type"
    t.string   "perm_resource"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions_roles", :id => false, :force => true do |t|
    t.integer "permission_id"
    t.integer "role_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "topics", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_sessions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "login_count"
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.string   "email"
    t.string   "locale"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

end
