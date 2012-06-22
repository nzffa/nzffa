module Marketplace
  include Radiant::Taggable
  desc 'Tags to load marketplace into the current page'

  tag 'adverts' do |tag|
    %{<div id="adverts"></div>
      <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
      <script type="text/javascript">$('#adverts').load('#{adverts_path}')</script>}
  end
end
