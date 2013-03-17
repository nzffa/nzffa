class Branch < ActiveRecord::Base
  belongs_to :group

  def slug
    name.downcase.gsub(' ', '')
  end
end
