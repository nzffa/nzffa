require 'fastercsv'

COLS =  {
  "CustomerID"         => 0,
  "CardRecordID"       => 1,
  "Name"               => 2,
  "CustomList1ID"      => 3,
  "CustomList2ID"      => 4,
  "Identifiers"        => 5,
  "CardIdentification" => 6,
  "Branch"             => 7,
  "Add 1"              => 8,
  "Add 2"              => 9,
  "Add 3"              => 10,
  "Add 4"              => 11,
  "POSTCODE"           => 12,
  "PHONE"              => 13,
  "EMAIL"              => 14,
  "Custom List 2"      => 15,
  "Paid"               => 16
}



def made_up_password
  str = ''
  6.times do
    str << (('a'..'z').to_a + ('1'..'9').to_a).sample
  end
  str
end

def attrs_from_row(row)
  {
    :forename => row[COLS['Name']].split(',')[0],
    :surname => row[COLS['Name']].split(',')[1],
    :nzffa_membership_id => row[COLS['CardIdentification']].to_i,
    :post_line1 => row[COLS['Add 1']],
    :post_line2 => row[COLS['Add 2']],
    :post_city => row[COLS['Add 3']],
    :post_province => row[COLS['Add 4']],
    :postcode => row[COLS['POSTCODE']],
    :phone => row[COLS['PHONE']],
    :email => row[COLS['EMAIL']]
  }
end

def valid_email?(email)
  email =~ /^.+@.+$/
end

GROUPS = {
  'A' => 201, # AMIGO
  'C' => 203, # Councillor
  'D' => 204, # Direct Debit
  'E' => 205, # Executive
  'I' => 209, # Indigenous
  'J' => 210, # Farm Forestry Timbers Branch
  'K' => 211, # Email National Newsletter
  'M' => 213, # Postal Mail
  'N' => 214, # Newsletter Editor
  'P' => 216, # President
  'Q' => 217, # Sequoia
  'R' => 218, # 2011
  'S' => 219, # Secretary
  'T' => 220, # Treasurer
  'U' => 221, # Eucalypt
  'V' => 222, # 2012
  'Y' => 225, # Cypress
  'Z' => 226, # Neil Barr Foundation Trustee
  'BR LIFE'  => 101,
  'COMP'     => 102,
  'LIFE'     => 107,
  'PD BR'    => 111,
  'MULTIPLE' => 109
}
def lookup_group(identifier)
  Group.find_by_id(GROUPS[identifier])
end

def assign_groups(reader, row)
  #add branch (column I) group
  #add letter code groups from column G
  #add group from column Q (if it exists)
  #ensure they only belong to each group once
  
  if branch = Group.find_by_id(row[COLS['Branch']].to_i)
    reader.groups << branch
  end

  identifiers_s = row[COLS['Identifiers']]
  unless identifiers_s.blank?
    identifiers = identifiers_s.split('')
    identifiers << row[COLS['Custom List 2']]
    identifiers.reject!(&:blank?)
    identifiers.each do |i|
      if group = lookup_group(i)
        reader.groups << group
      end
    end
  end

  reader.groups = reader.groups.uniq
end

FasterCSV.foreach('memberdatacsv.csv') do |row|
  attrs = attrs_from_row(row)
  unless reader = Reader.find_by_nzffa_membership_id(attrs[:nzffa_membership_id])
    reader = Reader.new(attrs)

    unless valid_email?(attrs[:email])
      reader.email = "#{attrs[:nzffa_membership_id]}@nzffa.org.nz"
      reader.password = 'member'+attrs[:nzffa_membership_id]
    else
      reader.password = made_up_password
    end

    if reader.save
      #puts "Saved reader: #{reader.id}, #{reader.name}, #{reader.email}"
    else
      puts "Failed reader: #{reader.nzffa_membership_id}, #{reader.name}, #{reader.email}. #{reader.errors.full_messages}"
    end
  end

  if reader.valid?
    assign_groups(reader, row)
    if reader.group_ids.include?(229)
      reader.group_ids << 230
    end
  end
end

puts 'Members missing email addresses:'
Reader.find(:all, :conditions => 'email like "%@nzffa.org.nz"').each do |reader|
  puts "#{reader.email} \t #{reader.name}"
end

#for each record r in csv
  #if nzffa_membership_id exists?
    #just update groups on that record
  #else
    #insert new record
    #and update groups
  
  #if they belong to a branch they get added to
    #NZFFA Admin Levy group (100)
    #FFR Access group (231)
    #NZ Tree Grower (NZ) group (80)

  #is a member of Farm Forestry Timbers group (229) then they get added to FFT Newsletter group (230).

#update groups
  #add branch (column I) group
  #add letter code groups from column G
  #add group from column Q (if it exists)
  #ensure they only belong to each group once
