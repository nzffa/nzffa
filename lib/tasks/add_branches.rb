branches_and_levys = [['Far North',            10],
                      ['Mid North',            10],
                      ['Lower North',          15],
                      ['Waikato',              10],
                      ['Waitomo',              5 ],
                      ['Bay of Plenty',        15],
                      ['Taupo & Districts',    8 ],
                      ['Gisborne/East Coast',  10],
                      ['Hawke\'s Bay',         13],
                      ['Taranaki',             18],
                      ['Middle Districts',     10],
                      ['Wairarapa',            15],
                      ['Wellington',           15],
                      ['Nelson',               10],
                      ['Marlborough',          10],
                      ['West Coast',           15],
                      ['North Canterbury',     10],
                      ['Central Canterbury',   15],
                      ['Ashburton',            10],
                      ['South Canterbury',     8 ],
                      ['North Otago',          7 ],
                      ['Mid Otago',            15],
                      ['South Otago',          7 ],
                      ['Southland',            17],
                      ['Men of Trees',         15],
                      ['Southern High Country',10]]

branches_and_levys.each do |bnl|
  branch = Branch.find_or_create_by_name(bnl[0])
  branch.update_attribute(:annual_levy, bnl[1])
  branch.update_attribute(:group_id, Group.find_or_create_by_name(bnl[0]).id)
end
