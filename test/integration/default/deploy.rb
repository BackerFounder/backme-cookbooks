# InSpec test for recipe ruby::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec/resources/

describe file('/etc/ssh/ssh_known_hosts') do
  its('content') { should match(%r{github\.com\ ssh-rsa}) }
end

describe key_rsa('/root/.ssh/id_rsa') do
  it { should be_private }
  it { should be_public }
  its('key_length') { should eq 2048 }
end

describe file('/srv/www/backme') do
  its('type') { should eq :directory }
  it { should be_directory }
end

# check the app is cloned via Gemfile
describe file('/srv/www/backme/Gemfile') do
  it { should exist }
end

