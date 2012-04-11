module Nzffa::UserExtensions
  
  def reader_user?
    # All the site editors get access to readers.
    true
  end
  
end
