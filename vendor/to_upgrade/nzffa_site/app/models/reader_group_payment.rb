class ReaderGroupPayment < ActiveRecord::Base
  belongs_to :reader
  belongs_to :group
  
  validates_numericality_of :amount
end