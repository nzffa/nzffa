class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :email
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.string :phone
      t.string :first_name
      t.string :last_name
      t.timestamps
    end
  end
  
  def self.down
    drop_table :people
  end
end
