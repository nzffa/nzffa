module Nzffa::ReaderExtensions

  def self.included base
    base.class_eval {
      has_many :reader_group_payments
    }
  end

end
