# InSpec test for cookbook nodejs

# The InSpec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec/resources/

describe command('node -v') do
  its('exit_status') { should eq 0 }
end

describe command('yarn -v') do
  its('exit_status') { should eq 0 }
end
