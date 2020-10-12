

describe user('deploy') do
  it { should exist }
  its('group') { should eq 'deploy' }
  its('home') { should eq '/home/deploy' }
  its('shell') { should eq '/bin/bash' }
end

describe key_rsa('/home/deploy/.ssh/id_rsa') do
  it { should be_private }
  its('key_length') { should eq 2048 }
end
