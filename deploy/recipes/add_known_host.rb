#
# Cookbook:: deploy
# Recipe:: add_known_host
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

deploy_user = node.run_state[:deploy_user]
deploy_group = node.run_state[:deploy_group]
deploy_home = node.run_state[:deploy_home]

execute "add #{node['deploy']['git_host']} to known_hosts" do
  user deploy_user
  group deploy_group
  command "ssh-keyscan #{node['deploy']['git_host']} >> #{deploy_home}/.ssh/known_hosts"
  not_if "grep -q \"`ssh-keyscan #{node['deploy']['git_host']}`\" #{deploy_home}/.ssh/known_hosts"
end
