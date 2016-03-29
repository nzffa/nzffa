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
      
      desc 'Emails marketplace expiry warning emails as required'
      task :email_warnings => :environment do
        Advert.find(:all, :conditions =>
                    {:expires_on => 7.days.from_now.to_date}).each do |advert|
          ExpiryMailer.deliver_warning_email(advert)
          puts "Emailed: #{advert.reader.email}"
        end
      end

      #desc 'Emails subscription expiry warning emails as required'
      #task :subscription_email_warnings => :environment do
        #@subscriptions = Subscription.expiring_on(30.days.from_now.to_date)
        #@subscriptions.each do |subscription|
          #NotifySubscriber.deliver_subscription_expiring_soon(subscription)
        #end
      #end

      #desc 'Emails subscription expiry emails, and expires subscriptions as required'
      #task :subscription_expiry => :environment do
        #@subscriptions = Subscription.expiring_on(Date.today.to_date)
        #@subscriptions.each do |subscription|
          #AppliesSubscriptionGroups.remove(subscription, subscription.reader)
          #NotifySubscriber.deliver_subscription_expired_email(subscription)
        #end
      #end

      desc 'Reapply the subscriprion groups. Dont choose this in a guess.'
      task :reapply_subscription_groups => :environment do
        Reader.find_each do |reader|
          before_ids = reader.group_ids.uniq
          AppliesSubscriptionGroups.remove(reader)
          if reader.has_active_subscription?
            AppliesSubscriptionGroups.apply(reader.active_subscription, reader)
          end
          after_ids = reader.group_ids.uniq
          removed_ids = before_ids - after_ids
          added_ids = after_ids - before_ids
          unless removed_ids.empty?
            puts "Removed #{removed_ids.inspect} from reader_id: #{reader.id}"
          end
          if added_ids.any?
            puts "Added #{added_ids.inspect} to reader_id: #{reader.id}"
          end
        end
        # Rebuild non-renewed members group
        group = Group.find(NzffaSettings.non_renewed_members_group_id)
        group.readers.clear
        last_year_subscriptions = Subscription.find(:all, :conditions => ['expires_on > ? and expires_on < ?', 1.year.ago.beginning_of_year, 1.year.ago.end_of_year])
        last_year_member_ids = last_year_subscriptions.map(&:reader_id)
        active_member_ids = Subscription.active.map(&:reader_id)
        non_renewed_members = Reader.find(:all, :conditions => {:id => (last_year_member_ids - active_member_ids)})
        group.readers << non_renewed_members
      end
    end
  end
end
