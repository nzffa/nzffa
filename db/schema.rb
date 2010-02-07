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

ActiveRecord::Schema.define(:version => 20081203140407) do

  create_table "adverts", :force => true do |t|
    t.integer  "person_id"
    t.string   "title"
    t.string   "location"
    t.text     "body"
    t.string   "ad_type"
    t.boolean  "status"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price"
  end

  create_table "assets", :force => true do |t|
    t.string   "caption"
    t.string   "title"
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "branches", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.string   "cell"
    t.string   "fax"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "config", :force => true do |t|
    t.string "key",         :limit => 40, :default => "", :null => false
    t.string "value",                     :default => ""
    t.text   "description"
  end

  add_index "config", ["key"], :name => "key", :unique => true

  create_table "extension_meta", :force => true do |t|
    t.string  "name"
    t.integer "schema_version", :default => 0
    t.boolean "enabled",        :default => true
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "notes"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  add_index "groups_users", ["group_id"], :name => "index_groups_users_on_group_id"
  add_index "groups_users", ["user_id"], :name => "index_groups_users_on_user_id"

  create_table "layouts", :force => true do |t|
    t.string   "name",          :limit => 100
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.string   "content_type",  :limit => 40
    t.integer  "lock_version",                 :default => 0
  end

  create_table "page_attachments", :force => true do |t|
    t.integer "asset_id"
    t.integer "page_id"
    t.integer "position"
  end

  create_table "page_parts", :force => true do |t|
    t.string  "name",      :limit => 100
    t.string  "filter_id", :limit => 25
    t.text    "content"
    t.integer "page_id"
  end

  add_index "page_parts", ["page_id", "name"], :name => "parts_by_page"

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "slug",          :limit => 100
    t.string   "breadcrumb",    :limit => 160
    t.string   "class_name",    :limit => 25
    t.integer  "status_id",                    :default => 1,     :null => false
    t.integer  "parent_id"
    t.integer  "layout_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.boolean  "virtual",                      :default => false, :null => false
    t.integer  "lock_version",                 :default => 0
    t.string   "description"
    t.string   "keywords"
    t.date     "appears_on"
    t.date     "expires_on"
    t.integer  "position",                     :default => 0,     :null => false
    t.integer  "group_id"
  end

  add_index "pages", ["class_name"], :name => "pages_class_name"
  add_index "pages", ["parent_id"], :name => "pages_parent_id"
  add_index "pages", ["slug", "parent_id"], :name => "pages_child_slug"
  add_index "pages", ["virtual", "status_id"], :name => "pages_published"

  create_table "person_branch_roles", :force => true do |t|
    t.integer  "person_id"
    t.integer  "role_id"
    t.integer  "branch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "person_branch_roles", ["branch_id"], :name => "index_person_branch_roles_on_branch_id"
  add_index "person_branch_roles", ["person_id"], :name => "index_person_branch_roles_on_person_id"
  add_index "person_branch_roles", ["role_id"], :name => "index_person_branch_roles_on_role_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "snippets", :force => true do |t|
    t.string   "name",          :limit => 100, :default => "", :null => false
    t.string   "filter_id",     :limit => 25
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.integer  "lock_version",                 :default => 0
  end

  add_index "snippets", ["name"], :name => "name", :unique => true

  create_table "string_fields", :force => true do |t|
    t.integer  "super_field_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "super_fields", :force => true do |t|
    t.integer  "field_holder_id"
    t.string   "field_holder_type"
    t.integer  "field_id"
    t.string   "field_type"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name",              :limit => 100
    t.string   "email"
    t.string   "login",             :limit => 40,  :default => "",    :null => false
    t.string   "crypted_password",  :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.boolean  "admin",                            :default => false, :null => false
    t.boolean  "developer",                        :default => false, :null => false
    t.text     "notes"
    t.integer  "lock_version",                     :default => 0
    t.string   "salt"
    t.string   "session_token"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "persistence_token"
  end

  add_index "users", ["login"], :name => "login", :unique => true

end
