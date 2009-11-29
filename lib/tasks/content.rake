namespace :nzffa do
  
  desc "adds pages based on parsed local HTML files"
  task :add_pages => :environment do
    require "hpricot"
    class String
      def middle string
        return if (!index(string))
        self[(index(string)+string.size)..-1]
      end
    end
    
    count = 0
    Dir["/Users/Mini/Sites/radiant_NZFFA/public/images/design/Pests/*"].each do |dir|
      # puts dir
      Dir["#{dir}/*"].each do |file_name|
        if (!File.directory?(file_name) && count<20)
          
          doc = open(file_name) { |f| Hpricot(f) }
          
          home_link = '<a href="../../Forestry-pests-and-diseases.html">Home</a><br />'
          body_string = (doc/'body').inner_html.to_s
          
          
          
          new_page_part = nil
          
          new_page = Page.create do |page|
            page.title = (doc/'title').inner_html
            page.slug = File.basename(file_name).sub(".html", "")
            page.parent_id = 13
            page.status_id = 100
            page.created_by_id = 1
            
            new_page_part = PagePart.create do |page_part|
              page_part.name = "body"
              correct_body = fix_links(body_string.middle(home_link))
              page_part.content = correct_body
            end
            
          end
          new_page.save
          new_page_part.page = new_page
          new_page_part.save
          
          puts (doc/'title').inner_html

          count+=1
        end    
      end
    end
    
    
  end
  
  
  def fix_links string
    doc = Hpricot(string)
    (doc/"a").each do |link|
      if link["href"] 
        if (link["href"] =~ /\A\.\.\/([A-Z])/)
          # puts link["href"]
          link["href"] = link["href"].sub(/\A\.\.\/([A-Za-z-]*)/, "/pests")
          link["href"] = link["href"].sub(".html", "")
          # puts link["href"]
        elsif (link["href"] =~ /\A[A-Za-z0-9\-_]*\.html\Z/)
          link["href"] = "/pests/"+link["href"].sub(".html", "")
          # puts link["href"]
        end
      end
    end
    doc.to_s
  end

end