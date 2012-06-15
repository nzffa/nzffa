class Advert < ActiveRecord::Base
  CATEGORIES = ['supplier of', 'timber for sale', 'buyer of', 'services']
  default_scope :order => 'created_at DESC'

  has_attached_file :image,
      :styles => { :medium => "640x480>", :thumb => "120x90>" },
      :path        => ":rails_root/public/attachments/:attachment/:id/:style/:basename.:extension",
      :url         => "/attachments/:attachment/:id/:style/:basename.:extension",
      :default_url => "/attachments/:attachment/missing/missing.png"
  validates_attachment_size :image, :in => 1.kilobytes..5.megabytes

  belongs_to :reader
  named_scope :not_expired, lambda { {:conditions => ['expires_on > ?', Date.today]} }
  named_scope :published, lambda { {:conditions => {:is_published => true}} }

  validates_presence_of :reader
  validates_presence_of :expires_on, :unless => :is_company_listing

  validates_length_of :title, :minimum => 3
  validates_length_of :body, :minimum => 15

  #validates_inclusion_of :category, :in => CATEGORIES

  def snippet
    if body.length > 78
      body[0..78]+"..."
    else
      body
    end
  end

  def to_param
		"#{id}-#{title}".gsub(/[^a-zA-Z0-9]/,"-")
	end

  def categories
    self[:categories].split('|')
  end

  def categories=(list)
    self[:categories] = list.join('|')
  end
end
