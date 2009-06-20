class Role < ActiveRecord::Base
	
	has_many :person_branch_roles
	has_many :branches, :through => :person_branch_roles
  has_many :persons, :through => :person_branch_roles
	
end
