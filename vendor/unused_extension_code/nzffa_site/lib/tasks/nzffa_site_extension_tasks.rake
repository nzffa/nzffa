namespace :radiant do
  namespace :extensions do
    namespace :nzffa_site do
      
      desc "Runs the migration of the Nzffa Site extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          NzffaSiteExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          NzffaSiteExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Nzffa Site to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from NzffaSiteExtension"
        Dir[NzffaSiteExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(NzffaSiteExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
      end  
    end
  end
end
