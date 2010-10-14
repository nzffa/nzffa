namespace :nzffa do
  desc "Fix up price, location, ad_type and status fields"
  task :fix_adverts => :environment do
    Advert.all.each do |a|
      a.price = (900_000*rand).to_i
      a.location = random_location
      a.ad_type = random_ad_type
      a.status = rand > 0.5
      a.save
    end
    puts "done!"
  end
  
  desc "Add some fake users"
  task :populate_readers => :environment do
    require 'populator'
    require 'faker'
    
    Reader.populate 500 do |u|
      u.first_name = Faker::Name.first_name
      u.last_name = Faker::Name.last_name
      
      u.mobile = rand>0.3 ? Faker::PhoneNumber.phone_number : nil
      u.email = rand>0.3 ? (rand>0.5 ? Faker::Internet.free_email : Faker::Internet.email) : nil
      
      u.login = "#{u.first_name}.#{u.last_name}".downcase
      u.address_1 = Faker::Address.street_address
      u.address_2 = Faker::Address.city
      u.postcode = Faker::Address.zip_code
      u.country_code = rand>0.3 ? "NZ" : Geography::country_codes.rand
      
      n = ((rand**4.8)*5+0.496).round
      puts "*"*n
      
      Membership.populate n do |m|
        m.reader_id = u.id
        m.group_id = groups.rand.id
      end
      
    end
  end
  
  def groups
    @groups ||= Group.all
  end

  def random_location
    %w[Dunedin Christchurch Gore Auckland Hamilton Invercargill].rand
  end
  def random_ad_type
    %w[For\ sale Wanted Job Worker].rand
  end
end
