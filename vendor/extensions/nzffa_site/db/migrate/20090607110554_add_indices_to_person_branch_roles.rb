class AddIndicesToPersonBranchRoles < ActiveRecord::Migration
  def self.up
    add_index :person_branch_roles, :person_id
		add_index :person_branch_roles, :branch_id
		add_index :person_branch_roles, :role_id
  end

  def self.down
    remove_index :person_branch_roles, :person_id
		remove_index :person_branch_roles, :branch_id
		remove_index :person_branch_roles, :role_id
  end
end
