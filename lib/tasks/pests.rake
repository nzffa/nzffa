#!/usr/bin/env ruby
require "rubygems"
require "hpricot"


class String
  def middle string
    return self if (!index(string))
    self[(index(string)+string.size)..-1]
  end
end


class NzffaParse
  attr_accessor :count
  attr_accessor :root_dir
  
  def dirs_before_root_count
    root_dir.split("/").size
  end
  
  def relative_path_array path
    dirs = path.split("/")
    dirs_after_root_count = dirs.size - dirs_before_root_count
    dirs.last( dirs_after_root_count )
  end
  
  def self.array_to_path array
    "/#{array.join("/")}"
  end
  
  def self.path_to_array path
    path.split("/").select { |s| s!="" }
  end
  
  
  
  def initialize root_dir
    self.count = 0
    self.root_dir = root_dir
  end
    
  def process_dir dir, need_index=true
    if need_index
      index_page = Dir["#{dir}/#{File.basename(dir)}.html"].first
      if index_page
        # puts "**#{index_page}"
        process_file index_page, dir
      else
        puts "#{dir} has no index file, reverting to blank page."
        make_blank_radiant_page! dir
      end
    end
    
    items = Dir["#{dir}/*"].select { |i| File.basename(i.sub(/\.[a-z]{1,5}\Z/i, ""))!=File.basename(dir) }
    items.each do |file_path|
      if File.directory?(file_path)
        process_dir(file_path) 
      else
        process_file(file_path, dir) 
      end
    end
  end

  def process_file file_path, dir
    doc = open(file_path) { |f| Hpricot(f) }
    home_link = '<a href="../../Forestry-pests-and-diseases.html">Home</a><br />'
    body_string = (doc/'body').inner_html.to_s
    body_string = Hpricot(body_string.middle(home_link))
    
    # if the file we are looking at has the same name as its folder, then it is to be use as the parent
    # (in radiant there are no dirs, pages are just nested under others)
    
    # puts file_path
    (body_string/"a").each do |link|
      process_link(link, file_path) if link["href"]
    end
    
    radiant_path = File.basename(file_path.sub(/\.[a-z]{1,5}\Z/i, ""))==File.basename(dir) ? dir : file_path.sub(/\.[a-z]{1,5}\Z/i, "")
    make_radiant_page! doc, body_string, radiant_path
    
  end

  def process_link link, file_path
    
    case link["href"]
    when /\Ahttp:\/\//      # if link does not begin with an http...
    when /\A\//             # ... and is not site-absolute...
    when /\Amailto:/        # ... and is a mail link...
    else                    # ... then it's relative! right?
      file_relative_path_array = relative_path_array( file_path )
      file_depth = file_relative_path_array.size
      linked_file_depth = file_depth
      
      # remove any extension from 1-5 chars long
      link["href"] = link["href"].sub /\.[a-z]{1,5}\Z/i, ""
      
      # remove any prepended "../"s but keep track of how far back we're going
      while link["href"][0..2] == "../"
        link["href"] = link["href"][3..-1]
        linked_file_depth -= 1
      end
      return if linked_file_depth < 0 ## Oops!
          
      # this should be a string representing the path to the linked file, apart from that still held in link["href"]
      path_start = NzffaParse.array_to_path( file_relative_path_array.first( linked_file_depth-1 ) )
      
      # should be the entire relative link
      link["href"] = "#{path_start}/#{link["href"]}"
      
      
      # for radiant, if a file has the same name as its folder, we are going to make it the index
      path_array = NzffaParse.path_to_array(link["href"])
      # puts "!!!!" if path_array[-1]==path_array[-2]
      path_array.pop if path_array[-1]==path_array[-2]
      
      link["href"] = NzffaParse.array_to_path(path_array)
      # puts "\t#{link["href"]}"
      # puts "#{root_dir}#{link["href"]}"
      # p `ls #{root_dir}#{link["href"]}*`
      
      # NzffaParse.array_to_path()
      self.count +=1
    end
    
  end
  
  def make_radiant_page! doc, content, radiant_path
    parent_path_array = NzffaParse.path_to_array(radiant_path)
    parent_path_array.pop
    parent_path = NzffaParse.array_to_path(parent_path_array)
    # Page.find_by_url(parent_paths)
    # parent_id = ??
    
    puts title = (doc/"title").inner_html.to_s
    puts slug = NzffaParse.path_to_array(radiant_path).last
    puts breadcrumb = title
    puts
    status_id = 100 # 100=published
    # exit
  end
  
  def make_blank_radiant_page! title
    
  end
end


namespace :nzffa do
  
desc "Recursively adds add the pests and diseases pages to the DB"
task :add => :environment do
  np = NzffaParse.new "/Users/Mini"
  np.process_dir "/Users/Mini/farm-forestry-model/", false
end

end