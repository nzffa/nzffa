class PersonBranchRole < ActiveRecord::Base
	belongs_to :person
	belongs_to :role
	belongs_to :branch
end
