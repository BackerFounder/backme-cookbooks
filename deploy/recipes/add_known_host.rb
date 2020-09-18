#
# Cookbook:: deploy
# Recipe:: add_known_host
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

execute "add #{node['deploy']['git_host']} to known_hosts" do
  user node['deploy']['user']
  group node['deploy']['group']
  command "ssh-keyscan #{node['deploy']['git_host']} >> /etc/ssh/ssh_known_hosts"
  not_if "grep -q \"`ssh-keyscan #{node['deploy']['git_host']}`\" /etc/ssh/ssh_known_hosts"
end
