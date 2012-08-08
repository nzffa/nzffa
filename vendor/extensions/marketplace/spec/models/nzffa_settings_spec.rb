require 'app/models/nzffa_settings'

describe NzffaSettings do
  it 'sets a key and value and returns the value' do
    NzffaSettings.set(:tree, 'eucalytpus').should == 'eucalytpus'
  end

  it 'returns a value for a key' do
    NzffaSettings.set(:tree, 'eucalytpus')
    NzffaSettings.get(:tree).should == 'eucalytpus'
  end
end
