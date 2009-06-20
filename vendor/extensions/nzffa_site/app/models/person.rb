class Person < ActiveRecord::Base
  set_table_name "users"
  
  acts_as_authentic do |c|
    c.login_field = "email"
    c.crypted_password_field = "password"
    c.password_salt_field = "salt"
    c.crypto_provider = Authlogic::CryptoProviders::Sha1
  end
  
  def perishable_token= *args
    session_token = *args
  end
  
  def perishable_token
    session_token
  end
  
  has_many :adverts
  has_many :people_branch_roles
  has_many :branches, :through => :people_branch_roles
  has_many :roles, :through => :people_branch_roles
  
  accepts_nested_attributes_for :people_branch_roles
  
  def full_name
    first_name + " " + last_name
  end
  
  
  
end