class ReaderGroupPayment < ActiveRecord::Base
  belongs_to :reader
  belongs_to :group
end