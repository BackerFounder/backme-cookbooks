#
# Cookbook:: cloud_watch
# Recipe:: aws_configure
#
# Copyright:: 2021, BackerFounder, All Rights Reserved.

deploy_user = node.run_state[:deploy_user]
deploy_group = node.run_state[:deploy_group]
deploy_home = node.run_state[:deploy_home]

aws_path = ::File.join(deploy_home, '.aws')

directory aws_path do
  owner deploy_user
  group deploy_group
  recursive true
end

template ::File.join(aws_path, 'credentials') do
  source 'credentials.erb'
  owner deploy_user
  group deploy_group
  helper(:aws_access_key) { node['cloud_watch']['aws_access_key'] }
  helper(:aws_access_secret) { node['cloud_watch']['aws_access_secret'] }
end
