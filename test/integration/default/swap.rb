describe command('swapon | grep /mnt/swap') do
  its('exit_status') { should eq 0 }
end
