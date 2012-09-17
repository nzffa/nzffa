namespace :radiant do
  namespace :extensions do
    namespace :marketplace do
      
      desc "Runs the migration of the Marketplace extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          MarketplaceExtension.migrator.migrate(ENV["VERSION"].to_i)
          Rake::Task['db:schema:dump'].invoke
        else
          MarketplaceExtension.migrator.migrate
          Rake::Task['db:schema:dump'].invoke
        end
      end
      
      desc "Copies public assets of the Marketplace to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from MarketplaceExtension"
        Dir[MarketplaceExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(MarketplaceExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
      end  
      
      desc "Syncs all available translations for this ext to the English ext master"
      task :sync => :environment do
        # The main translation root, basically where English is kept
        language_root = MarketplaceExtension.root + "/config/locales"
        words = TranslationSupport.get_translation_keys(language_root)
        
        Dir["#{language_root}/*.yml"].each do |filename|
          next if filename.match('_available_tags')
          basename = File.basename(filename, '.yml')
          puts "Syncing #{basename}"
          (comments, other) = TranslationSupport.read_file(filename, basename)
          words.each { |k,v| other[k] ||= words[k] }  # Initializing hash variable as empty if it does not exist
          other.delete_if { |k,v| !words[k] }         # Remove if not defined in en.yml
          TranslationSupport.write_file(filename, basename, comments, other)
        end
      end

      desc 'Emails marketplace expiry warning emails as required'
      task :email_warnings => :environment do
        Advert.find(:all, :conditions =>
                    {:expires_on => 7.days.from_now.to_date}).each do |advert|
          ExpiryMailer.deliver_warning_email(advert)
          puts "Emailed: #{advert.reader.email}"
        end
      end

      desc 'Emails subscription expiry warning emails as required'
      task :subscription_email_warnings => :environment do
        @subscriptions = Subscription.expiring_on(30.days.from_now.to_date)
        @subscriptions.each do |subscription|
          NotifySubscriber.deliver_subscription_expiring_soon(subscription)
        end
      end

      desc 'Emails subscription expiry emails, and expires subscriptions as required'
      task :subscription_expiry => :environment do
        @subscriptions = Subscription.expiring_on(Date.today.to_date)
        @subscriptions.each do |subscription|
          AppliesSubscriptionGroups.remove(subscription, subscription.reader)
          NotifySubscriber.deliver_subscription_expired_email(subscription)
        end
      end
    end
  end
end
