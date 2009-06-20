module Admin::MarketplaceHelper
  
  # def title text
  #   "<h2>#{text}</h2>"
  # end
  
  def make_pretty string
    string.gsub("\n", "<br/>")
  end
  
  
  def advert_order_link name
    if params[:sort]==name #if we are already sorting by this, reverse the sort
      name << "_reversed"
    end
    link_to_remote name,
      { :url => {:action=>'index',
          :params=>params.merge({:sort => name})}, #this will preserve the other params (query, or page)
      :update => "table", #id of the div to update
      :method => "get"}   #must use the get method
  end

	def ad_type_badge(ad_type)
		%Q{<span class="#{ ad_type.downcase.gsub(" ", "_") } ad_type">
      #{ ad_type }
    </span>}
	end
end
