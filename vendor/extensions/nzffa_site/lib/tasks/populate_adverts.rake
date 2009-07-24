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

  def random_location
    locations = %w[Dunedin Christchurch Gore Auckland Hamilton Invercargill]
    locations[(rand*locations.length).to_i]
  end
  def random_ad_type
    types = %w[For\ sale Wanted Job Worker]
    types[(rand*types.length).to_i]
  end
end