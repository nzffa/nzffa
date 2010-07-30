module Nzffa::ReaderExtensions
  
  def self.included base
    base.class_eval {
      default_scope :order => 'first_name ASC'
    }
  end
  
  def name
    full_name = [honorific, first_name, last_name].compact.join(" ")
    full_name.blank? ? login : full_name
  end
  
  def name= s
    name_parts = s.split(/\s+/)
    
    self.first_name = name_parts[0] if self.first_name.blank? && name_parts[0]
    self.last_name  = name_parts[1] if self.last_name.blank? && name_parts[1]
  end
  
  def name_changed?
    first_name_changed? || last_name_changed?
  end
  
end
