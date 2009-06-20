class CreatePersonBranchRoles < ActiveRecord::Migration
  def self.up
    create_table :person_branch_roles do |t|
      t.integer :person_id
      t.integer :role_id
      t.integer :branch_id

      t.timestamps
    end
  end

  def self.down
    drop_table :person_branch_roles
  end
end
