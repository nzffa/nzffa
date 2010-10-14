namespace :nzffa do
  
  desc "Import readers from the MYOB based csv"
  task :import_readers => :environment do
    mappings = {
      "CardIdentification" => "id",
      "LastName"           => "last_name",
      "FirstName"          => "first_name",
      "billing_address_1"  => "billing_address_1",
      "billing_address_2"  => "billing_address_2",
      "billing_address_3"  => "billing_address_3",
      "billing_address_4"  => "billing_address_4",
      "POSTCODE"           => "billing_postcode",
      "shipto_address_1"   => "address_1",
      "shipto_address_2"   => "address_2",
      "shipto_address_3"   => "address_3",
      "shipto_address_4"   => "address_4",
      "Postcode2"          => "postcode",
      "Contactperson"      => "contact_person",
      "Phone"              => "phone",
      "Fax"                => "fax",
      "mobile"             => "mobile",
      "email"              => "email"
    }
    import_models_from_csv( Reader, "readers", "login", mappings)
  end
  
  desc "Import groups from the MYOB based csv"
  task :import_groups => :environment do
    import_models_from_csv( Group, "groups", "name", { "ID" => "id", "Role" => "name", "Consequence" => "notes" })
  end
  
  desc "Import memberships from the MYOB based csv"
  task :import_memberships => :environment do
    import_models_from_csv( Membership, "memberships", "id", { "Member_id" => "reader_id", "Role_type_id" => "group_id" })
  end
  
  
  
  def import_models_from_csv( model_class, csv_name, name_column, mappings )
    require "csv-mapper"
    
    results = CsvMapper.import("db/csvs/#{csv_name}.csv") do
      # skip the headings:
      start_at_row 1
      
      read_attributes_from_file( mappings )
    end
    
    results.each do |r|
      instance = if (r["id"] rescue nil)
        model_class.find_or_create_by_id(r["id"])
      else
        model_class.new 
      end
      mappings.values.each do |column|
        instance[column] = r[column]
      end
      if instance.respond_to? :login
        instance.login = instance.email.blank? ? instance.last_name.downcase.gsub(/[^a-z]/, '')+rand(500).to_s : instance.email
      end
      instance.save(false)
      puts "saved '#{instance[name_column]}'!"
    end
  end
  
end


# 
# read_attributes_from_file( mappings )