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

ActiveRecord::Schema.define(:version => 20130226231316) do

  create_table "action_groups", :force => true do |t|
    t.string   "name"
    t.integer  "group_id"
    t.decimal  "annual_levy", :precision => 8, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "action_groups_subscriptions", :force => true do |t|
    t.integer "action_group_id"
    t.integer "subscription_id"
  end

  add_index "action_groups_subscriptions", ["action_group_id"], :name => "index_action_groups_subscriptions_on_action_group_id"
  add_index "action_groups_subscriptions", ["subscription_id"], :name => "index_action_groups_subscriptions_on_subscription_id"

  create_table "adverts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "categories"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "expires_on"
    t.integer  "reader_id"
    t.string   "timber_species"
    t.boolean  "is_company_listing",   :default => false
    t.text     "timber_for_sale"
    t.text     "supplier_of"
    t.text     "buyer_of"
    t.text     "services"
    t.text     "business_description"
    t.text     "admin_notes"
    t.boolean  "ffr_contact"
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
    t.boolean  "furniture",          :default => false
    t.string   "uuid"
    t.integer  "original_width"
    t.integer  "original_height"
    t.string   "original_extension"
  end

  create_table "branches", :force => true do |t|
    t.string  "name"
    t.decimal "annual_levy", :precision => 8, :scale => 2
    t.integer "group_id"
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

  create_table "forums", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "position"
    t.integer  "lock_version",  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.integer  "old_id"
    t.integer  "topics_count",  :default => 0, :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.integer  "homepage_id"
    t.integer  "site_id"
    t.integer  "lock_version"
    t.boolean  "public"
    t.text     "invitation"
    t.string   "slug"
    t.string   "ancestry"
  end

  add_index "groups", ["ancestry"], :name => "index_groups_on_ancestry"

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

  create_table "memberships", :force => true do |t|
    t.integer "group_id"
    t.integer "reader_id"
    t.string  "role"
    t.boolean "admin"
  end

  create_table "message_readers", :force => true do |t|
    t.integer  "site_id"
    t.integer  "message_id"
    t.integer  "reader_id"
    t.datetime "sent_at"
  end

  create_table "messages", :force => true do |t|
    t.integer  "site_id"
    t.string   "subject"
    t.text     "body"
    t.text     "filter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.integer  "lock_version"
    t.string   "function_id"
    t.integer  "status_id",     :default => 1
    t.integer  "layout_id"
    t.datetime "sent_at"
  end

  create_table "order_lines", :force => true do |t|
    t.integer  "order_id"
    t.string   "kind"
    t.string   "particular"
    t.decimal  "amount",        :precision => 8, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_refundable",                               :default => true
  end

  add_index "order_lines", ["order_id"], :name => "index_order_lines_on_order_id"

  create_table "orders", :force => true do |t|
    t.decimal  "amount",              :precision => 10, :scale => 2
    t.date     "paid_on"
    t.integer  "subscription_id"
    t.string   "kind"
    t.integer  "old_subscription_id"
    t.string   "payment_method"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "details"
  end

  add_index "orders", ["subscription_id"], :name => "index_orders_on_subscription_id"

  create_table "page_attachments", :force => true do |t|
    t.integer "asset_id"
    t.integer "page_id"
    t.integer "position"
  end

  create_table "page_fields", :force => true do |t|
    t.integer "page_id"
    t.string  "name"
    t.string  "content"
  end

  add_index "page_fields", ["page_id", "name", "content"], :name => "index_page_fields_on_page_id_and_name_and_content"

  create_table "page_parts", :force => true do |t|
    t.string  "name",      :limit => 100
    t.string  "filter_id", :limit => 25
    t.text    "content",   :limit => 16777215
    t.integer "page_id"
  end

  add_index "page_parts", ["page_id", "name"], :name => "parts_by_page"

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "slug",                   :limit => 100
    t.string   "breadcrumb",             :limit => 160
    t.string   "class_name",             :limit => 25
    t.integer  "status_id",                             :default => 1,     :null => false
    t.integer  "parent_id"
    t.integer  "layout_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.boolean  "virtual",                               :default => false, :null => false
    t.integer  "lock_version",                          :default => 0
    t.date     "appears_on"
    t.date     "expires_on"
    t.integer  "position",                              :default => 0,     :null => false
    t.integer  "group_id"
    t.text     "allowed_children_cache"
    t.boolean  "commentable",                           :default => true
    t.boolean  "comments_closed",                       :default => false
    t.datetime "replied_at"
    t.integer  "replied_by_id"
  end

  add_index "pages", ["class_name"], :name => "pages_class_name"
  add_index "pages", ["parent_id"], :name => "pages_parent_id"
  add_index "pages", ["slug", "parent_id"], :name => "pages_child_slug"
  add_index "pages", ["virtual", "status_id"], :name => "pages_published"

  create_table "people", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "phone"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.integer "group_id"
    t.integer "permitted_id"
    t.string  "permitted_type"
  end

  create_table "post_attachments", :force => true do |t|
    t.integer  "post_id"
    t.integer  "reader_id"
    t.integer  "position"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "old_id"
  end

  create_table "posts", :force => true do |t|
    t.integer  "reader_id"
    t.integer  "topic_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "old_id"
    t.integer  "page_id"
    t.text     "search_text"
  end

  add_index "posts", ["created_at"], :name => "index_posts_on_forum_id"
  add_index "posts", ["reader_id", "created_at"], :name => "index_posts_on_reader_id"

  create_table "reader_group_payments", :force => true do |t|
    t.integer  "reader_id"
    t.integer  "group_id"
    t.float    "amount"
    t.date     "payment_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year_for"
  end

  create_table "reader_group_payments_dummy", :force => true do |t|
    t.integer  "reader_id"
    t.integer  "group_id"
    t.float    "amount"
    t.date     "payment_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year_for"
  end

  create_table "readers", :force => true do |t|
    t.integer  "site_id"
    t.integer  "user_id"
    t.string   "honorific"
    t.string   "surname"
    t.string   "forename"
    t.string   "email"
    t.text     "description"
    t.text     "notes"
    t.string   "fax"
    t.string   "mobile"
    t.datetime "activated_at"
    t.string   "physical_address"
    t.string   "country_code"
    t.string   "post_line1"
    t.string   "post_line2"
    t.string   "region"
    t.string   "postcode"
    t.string   "contact_person"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.boolean  "trusted",                 :default => true
    t.boolean  "receive_email",           :default => true
    t.boolean  "receive_essential_email", :default => true
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "provisional_password"
    t.integer  "login_count",             :default => 0,     :null => false
    t.integer  "failed_login_count",      :default => 0,     :null => false
    t.string   "session_token"
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "clear_password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone"
    t.string   "organisation"
    t.string   "post_organisation"
    t.string   "post_city"
    t.string   "post_province"
    t.string   "post_country"
    t.boolean  "unshareable"
    t.text     "unshared"
    t.datetime "current_login_at"
    t.string   "nickname"
    t.string   "name"
    t.date     "dob"
    t.boolean  "dob_secret"
    t.boolean  "disabled",                :default => false
    t.string   "website"
    t.integer  "nzffa_membership_id"
    t.integer  "posts_count",             :default => 0
    t.integer  "old_id"
    t.string   "special_cases"
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

  create_table "submenu_links", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "user_id"
    t.integer  "site_id"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "submenu_links", ["site_id", "user_id"], :name => "index_links_by_site_and_user"

  create_table "subscriptions", :force => true do |t|
    t.string   "membership_type"
    t.integer  "reader_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ha_of_planted_trees"
    t.string   "term"
    t.integer  "main_branch_id"
    t.boolean  "belong_to_fft",                          :default => false, :null => false
    t.date     "expires_on"
    t.string   "tree_grower_delivery_location"
    t.boolean  "receive_tree_grower_magazine"
    t.date     "begins_on"
    t.date     "cancelled_on"
    t.text     "special_interest_groups"
    t.integer  "nz_tree_grower_copies",                  :default => 1
    t.boolean  "contribute_to_research_fund",            :default => false, :null => false
    t.float    "research_fund_contribution_amount"
    t.boolean  "research_fund_contribution_is_donation", :default => false
  end

  add_index "subscriptions", ["reader_id"], :name => "index_subscriptions_on_reader_id"

  create_table "subscriptions_branches", :force => true do |t|
    t.integer  "subscription_id"
    t.integer  "branch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions_branches", ["branch_id"], :name => "index_subscriptions_branches_on_branch_id"
  add_index "subscriptions_branches", ["subscription_id"], :name => "index_subscriptions_branches_on_subscription_id"

  create_table "topics", :force => true do |t|
    t.integer  "forum_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "replied_at"
    t.integer  "hits",          :default => 0
    t.boolean  "sticky",        :default => false
    t.boolean  "locked",        :default => false
    t.integer  "replied_by_id"
    t.integer  "old_id"
  end

  add_index "topics", ["forum_id", "replied_at"], :name => "index_topics_on_forum_id_and_replied_at"
  add_index "topics", ["forum_id", "sticky", "replied_at"], :name => "index_topics_on_sticky_and_replied_at"
  add_index "topics", ["forum_id"], :name => "index_topics_on_forum_id"

  create_table "users", :force => true do |t|
    t.string   "name",          :limit => 100
    t.string   "email"
    t.string   "login",         :limit => 40,  :default => "",    :null => false
    t.string   "password",      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.boolean  "admin",                        :default => false, :null => false
    t.boolean  "designer",                     :default => false, :null => false
    t.text     "notes"
    t.integer  "lock_version",                 :default => 0
    t.string   "salt"
    t.string   "session_token"
    t.string   "locale"
  end

  add_index "users", ["login"], :name => "login", :unique => true

end
