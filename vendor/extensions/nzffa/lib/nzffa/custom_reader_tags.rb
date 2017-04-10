module Nzffa::CustomReaderTags
  include Radiant::Taggable
  
  class TagError < StandardError; end

  [:post_city, :post_country, :post_province, :postcode, :post_line1, :post_line2, :phone, :mobile].each do |field|
    desc %{
      Displays the #{field} field of the current reader.
      <pre><code><r:reader:#{field} /></code></pre>
    }
    tag "reader:#{field}" do |tag|
      tag.locals.reader.send(field) if tag.locals.reader
    end
  end
  
  desc %{
    Displays the full postal address recorded for the current reader.
    The 'newline' attribute defaults to a newline (\\n).
    <pre><code><r:reader:postal_address [newline="<br/>"] /></code></pre>
  }
  tag "reader:postal_address" do |tag|
    if tag.locals.reader
      newline = tag.attr['newline'] || "\n"
      tag.render('reader:post_line1') + newline +
      ((tag.render('reader:post_line2') + newline) unless tag.render('reader:post_line2').blank?).to_s +
      tag.render('reader:post_city') + newline +
      tag.render('reader:postcode') + newline +
      ((tag.render('reader:post_province') + newline) unless tag.render('reader:post_province').blank?).to_s +
      tag.render('reader:post_country')
    end
  end
end
