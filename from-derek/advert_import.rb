# To use:
# script/runner advert_import.rb
require 'csv'

# columns from the CSV, preserve order and newlines.
columns = "
  readers.forename
  readers.surname
  readers.billing_address_4
  readers.billing_address_1
  readers.phone
  readers.mobile
  readers.fax

  readers.contact_person
  adverts.timber_species
  adverts.timber_for_sale
  adverts.supplier_of
  adverts.services
  adverts.website
  adverts.business_description
  
  membership.group
  readers.organisation
  readers.address_1 
  readers.billing_postcode
  adverts.admin_notes
  adverts.ffr_contact
  readers.email
  c 
  adverts.buyer_of"

# what groups what entry in the groups column gets us
#groups_for = {
  #"Newsletter" => [Group.find(230)],
  #"Associate"  => [Group.find(229)],
  #"NZFFA"      => [Group.find(229), Group.find(100)]
#}

# create hash from columns
h = {}
columns.each_with_index do |name, index|
  next unless name.include?(".")
  table, field = name.split(".").map &:strip
  h[table] ||= {}
  h[table][field] = index
end

# return an active_record ready hash for a row
def values_for columns, row
  columns.inject({}) do |hash, (field, index)|
    hash[field] = row[index].try :strip
    hash
  end
end

# process the csv, creating one reader, one ad and one or two group memberships for each row
# note we save without validations
row_count = 0
CSV.foreach("FFT_Data.csv") do |row|
  next if (row_count+=1) <= 2

  reader = Reader.new values_for(h["readers"], row)
  group_name = row[h["membership"]["group"]]
  #reader.groups += groups_for[group_name]
  reader.save(false)

  advert_values = values_for(h["adverts"], row).merge(
    :reader_id => reader.id,
    :is_company_listing => true,
    :ffr_contact => row[h["adverts"]["ffr_contact"]].downcase.strip == "yes"
  )

  advert = Advert.create advert_values
  advert.save(false)
end


