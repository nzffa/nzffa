class AddNzffaFieldsToReaders < ActiveRecord::Migration
  def self.up
    drop_table :readers
    create_table :readers, :force => true do |t|
      t.integer  "site_id"
      t.integer  "user_id"

      t.string   "login",                    :limit => 40,  :default => "",    :null => false
      t.string   "honorific"
      t.string   "last_name"
      t.string   "first_name"
      t.string   "email"
      t.text     "description"
      t.text     "notes"

      t.string   "fax"
      t.string   "mobile"

      t.datetime "activated_at"

      t.string   "address_1"
      t.string   "address_2"
      t.string   "address_3"
      t.string   "address_4"
      t.string   "postcode"
      t.string   "country"
      
      t.string   "billing_address_1"
      t.string   "billing_address_2"
      t.string   "billing_address_3"
      t.string   "billing_address_4"
      t.string   "billing_postcode"
      t.string   "billing_country"
      
      t.string   "contact_person"

      t.integer  "created_by_id"
      t.integer  "updated_by_id"

      t.boolean  "trusted",                  :default => true
      t.boolean  "receive_email",            :default => true
      t.boolean  "receive_essential_email",  :default => true

      t.string   "crypted_password"
      t.string   "password_salt"
      t.string   "provisional_password"

      t.integer  "login_count",              :default => 0,     :null => false
      t.integer  "failed_login_count",       :default => 0,     :null => false

      t.string   "session_token"
      t.datetime "last_request_at"
      t.datetime "last_login_at"
      t.string   "persistence_token"
      t.string   "single_access_token"
      t.string   "perishable_token"
      t.string   "current_login_ip"
      t.string   "last_login_ip"
      t.string   "clear_password"
      
      t.timestamps
    end
  end

  def self.down
    drop_table :readers
    create_table "readers", :force => true do |t|
      t.integer  "site_id"
      t.string   "name",                    :limit => 100
      t.string   "email"
      t.string   "login",                   :limit => 40,  :default => "",    :null => false
      t.string   "crypted_password"
      t.text     "description"
      t.text     "notes"
      t.boolean  "trusted",                 :default => true
      t.boolean  "receive_email",           :default => false
      t.boolean  "receive_essential_email", :default => true
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "created_by_id"
      t.integer  "updated_by_id"
      t.string   "password_salt"
      t.string   "session_token"
      t.string   "provisional_password"
      t.datetime "activated_at"
      t.string   "honorific"
      t.integer  "user_id"
      t.datetime "last_request_at"
      t.datetime "last_login_at"
      t.string   "persistence_token",       :default => "",    :null => false
      t.string   "single_access_token",     :default => "",    :null => false
      t.string   "perishable_token",        :default => "",    :null => false
      t.integer  "login_count",             :default => 0,     :null => false
      t.integer  "failed_login_count",      :default => 0,     :null => false
      t.string   "current_login_ip"
      t.string   "last_login_ip"
      t.string   "clear_password"
      t.string   "forename"
      t.string   "phone"
      t.string   "organisation"
      t.string   "post_building"
      t.string   "post_street"
      t.string   "post_place"
      t.string   "post_town"
      t.string   "post_county"
      t.string   "postcode"
    end
  end
end