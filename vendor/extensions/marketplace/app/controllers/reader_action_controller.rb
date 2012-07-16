class ReaderActionController < ApplicationController
  def default_welcome_url(reader=nil)
    '/your-account/'
  end
end
