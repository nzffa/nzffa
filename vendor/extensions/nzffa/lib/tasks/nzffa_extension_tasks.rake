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

      #desc 'Emails subscription expiry emails, and expires subscriptions as required'
      #task :subscription_expiry => :environment do
        #@subscriptions = Subscription.expiring_on(Date.today.to_date)
        #@subscriptions.each do |subscription|
          #AppliesSubscriptionGroups.remove(subscription, subscription.reader)
          #NotifySubscriber.deliver_subscription_expired_email(subscription)
        #end
      #end

      desc 'Reapply the subscription groups. Non-destructive; run as often as you like.'
      task :reapply_subscription_groups => :environment do
        Reader.find_each do |reader|
          next if reader.is_resigned?
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
        # Rebuild non-renewed members groups
        group = Group.find(NzffaSettings.non_renewed_members_group_id)
        group.readers.clear
        last_year_subscriptions = Subscription.find(:all, :conditions => ['expires_on > ? and expires_on < ? and membership_type = "full"', 1.year.ago.beginning_of_year, 1.year.ago.end_of_year])
        last_year_member_ids = last_year_subscriptions.map(&:reader_id)
        active_member_ids = Subscription.active.find(:all, :conditions => "membership_type = 'full'").map(&:reader_id)
        non_renewed_members = Reader.find(:all, :conditions => {:id => (last_year_member_ids - active_member_ids)}).select{|r| !r.is_resigned? }
        group.readers << non_renewed_members
        puts "Added #{non_renewed_members.size} readers to non_renewed_members group"
        casual_group = Group.find(NzffaSettings.non_renewed_casual_members_group_id)
        casual_ex_fft = Group.find(NzffaSettings.non_renewed_cas_fft_members_group_id)
        casual_group.readers.clear
        casual_ex_fft.readers.clear
        
        last_year_tg_subscriptions = Subscription.find(:all, :conditions => ['expires_on > ? and expires_on < ? and membership_type = "casual" and receive_tree_grower_magazine = ?', 1.year.ago.beginning_of_year, 1.year.ago.end_of_year, true])
        last_year_tg_member_ids = last_year_tg_subscriptions.map(&:reader_id)
        active_tg_member_ids = Subscription.active.find(:all, :conditions => ["membership_type = 'casual' and receive_tree_grower_magazine = ?", true]).map(&:reader_id)
        non_renewed_tg_members = Reader.find(:all, :conditions => {:id => (last_year_tg_member_ids - active_tg_member_ids)}).select{|r| !r.is_resigned? }
        casual_group.readers << non_renewed_tg_members
        
        last_year_fft_subscriptions = Subscription.find(:all, :conditions => ['expires_on > ? and expires_on < ? and membership_type = "casual"', 1.year.ago.beginning_of_year, 1.year.ago.end_of_year]).select{|s| s.belongs_to_fft }
        last_year_fft_member_ids = last_year_fft_subscriptions.map(&:reader_id)
        active_fft_member_ids = Subscription.active.find(:all, :conditions => "membership_type = 'casual'").select{|s| s.belongs_to_fft }.map(&:reader_id)
        non_renewed_fft_members = Reader.find(:all, :conditions => {:id => (last_year_fft_member_ids - active_fft_member_ids)}).select{|r| !r.is_resigned? }
        casual_ex_fft.readers << non_renewed_fft_members
        
        puts "Added #{non_renewed_tg_members.size} readers to non_renewed_casual_members group"
        puts "Added #{non_renewed_fft_members.size} readers to non_renewed_fft_members group"
      end
    end
  end
end
