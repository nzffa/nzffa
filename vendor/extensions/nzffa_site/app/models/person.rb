class Person < ActiveRecord::Base
  acts_as_authentic
  
  has_many :adverts
  has_many :people_branch_roles
  has_many :branches, :through => :people_branch_roles
  has_many :roles, :through => :people_branch_roles
  
  accepts_nested_attributes_for :people_branch_roles
  
  def full_name
    first_name + " " + last_name
  end
end