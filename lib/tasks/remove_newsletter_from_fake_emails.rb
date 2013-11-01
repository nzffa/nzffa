Reader.find(:all, :conditions => 'email like "%@nzffa.org.nz"').each do |reader|
  reader.receive_nzffa_members_newsletter = false
end
