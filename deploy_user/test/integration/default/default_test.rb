# InSpec test for recipe ruby::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec/resources/

describe user('deploy') do
  it { should exist }
  its('groups') { should include deploy }
  its('home') { should eq '/home/deploy' }
  its('shell') { should eq '/bin/bash' }
end
