class Advert < ActiveRecord::Base  
  default_scope :order => 'created_at DESC'
  belongs_to :person
  
  has_attached_file :image, :styles => { :medium => "640x480>", :thumb => "120x90>" },
      :url         => "/attachments/:attachment/:id/:style/:filename",
      :default_url => "/attachments/:attachment/missing/missing.png"
      
  validates_attachment_size :image, :in => 1.kilobytes..5.megabytes
  
  cattr_reader :ad_types
  @@ad_types = %w[For\ Sale Wanted Job Worker]
  
  validates_presence_of :person
  validates_length_of :title, :minimum => 3
  validates_length_of :body, :minimum => 15
  validates_inclusion_of :ad_type, :in => @@ad_types
  
  def validate
    return if @dollars.nil? || @dollars.blank? #allow no value to be entered
    begin
      num = Kernel.Float(@dollars) #will throw an error unless @dollars is clean
    rescue
      errors.add(:dollars, "should be just a number")
    end
  end
  
  # we have to use a lambda here, so that 4.weeks.ago, and Time.now are calculated at request time,
  # not at application start time.
  named_scope :active,  lambda { |*args| {:conditions => { :created_at => 4.weeks.ago..Time.now, :status => true} }}
  named_scope :disabled, :conditions => { :status=> false } 
  
  def dollars
    price/100.00 if price
  end
  
  def dollars= num
    if num.nil? || num.blank? #let price be null in the DB
      self.price = nil
    else
      @dollars = num
      self.price = num.to_f*100
    end
  end

  def snippet
    if body.length > 78
      body[0..78]+"..."
    else
      body
    end
  end

end
