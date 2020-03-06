namespace :radiant do
  namespace :extensions do
    namespace :nzffa do

      desc "Runs the migration of the Nzffa extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          NzffaExtension.migrator.migrate(ENV["VERSION"].to_i)
          Rake::Task['db:schema:dump'].invoke
        else
          NzffaExtension.migrator.migrate
          Rake::Task['db:schema:dump'].invoke
        end
      end

      desc "Copies public assets of the Nzffa to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from NzffaExtension"
        Dir[NzffaExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(NzffaExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
      end

      desc "Syncs all available translations for this ext to the English ext master"
      task :sync => :environment do
        # The main translation root, basically where English is kept
        language_root = NzffaExtension.root + "/config/locales"
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

      desc 'Emails subscription expiry warning emails as required'
      # Sent out once a year on November 14th ...
      task :subscription_email_warnings => :environment do
        @subscriptions = Subscription.active.expiring_on(Time.now.end_of_year.to_date)
        @subscriptions.each do |subscription|
          # unless if the renewal is free
          next if !(CreateOrder.from_subscription(subscription.renew_for_year(Time.now.end_of_year + 1.year)).amount > 0)
          # .. or if the reader already has a subscription for next year
          next if subscription.reader.has_subscription_for_next_year?
          # .. or if the reader is marked to disallow renewal emails
          next if subscription.reader.disallow_renewal_mails
          NotifySubscriber.deliver_subscription_expiring_soon(subscription)
          puts "Emailed subscription renewal to #{subscription.reader.email}"
        end
      end

      desc 'Synchronize Xero payments to mark orders completed'
      task :synchronize_xero_payments => :environment do
        XeroSync.create
        puts "Synchronizing payments from Xero"
      end
      #desc 'Emails subscription expiry emails, and expires subscriptions as required'
      #task :subscription_expiry => :environment do
        #@subscriptions = Subscription.expiring_on(Date.today.to_date)
        #@subscriptions.each do |subscription|
          #AppliesSubscriptionGroups.remove(subscription, subscription.reader)
          #NotifySubscriber.deliver_subscription_expired_email(subscription)
        #end
      #end
    end
  end
end
