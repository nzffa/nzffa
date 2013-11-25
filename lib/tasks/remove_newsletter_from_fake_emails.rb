Reader.find(:all, :conditions => 'email like "%@nzffa.org.nz"').map do |reader|
  reader.receive_nzffa_members_newsletter = false
  reader.email
end
