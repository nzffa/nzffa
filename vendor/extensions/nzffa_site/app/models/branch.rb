class Branch < ActiveRecord::Base
  
  has_many :person_branch_roles
  has_many :people, :through => :person_branch_roles
  has_many :roles, :through => :person_branch_roles
  
  def secretary
    secretary_role = Role.find_by_name "Branch Secretary"
    ubr = person_branch_roles.find_by_role_id(secretary_role.id)
    ubr.person if ubr
  end
  
end
