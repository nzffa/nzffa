class AdminController < ApplicationController
  before_filter :require_admin

  def require_admin
    # this might very well be silly
  end
end
