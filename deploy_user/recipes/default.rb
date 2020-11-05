#
# Cookbook:: deploy_user
# Recipe:: default
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

include_recipe 'deploy_user::pass_vars'

app = search(:aws_opsworks_app).first
aws_users = search(:aws_opsworks_user)
deploy_user = node.run_state[:deploy_user]
deploy_group = node.run_state[:deploy_group]
deploy_home = node.run_state[:deploy_home]


group deploy_group

user deploy_user do
  gid deploy_group
  shell '/bin/bash'
  manage_home true
end

directory "#{deploy_home}/.ssh" do
  owner deploy_user
  group deploy_group
  recursive true
  mode '0700'
end

template "#{deploy_home}/.ssh/authorized_keys" do
  source 'authorized_keys.erb'
  owner deploy_user
  group deploy_group
  helper(:aws_users) { aws_users }
end

file "#{deploy_home}/.ssh/id_rsa" do
  action :create
  owner deploy_user
  group deploy_group
  content app['app_source']['ssh_key']
  mode '0600'
  only_if do app['app_source'].has_key?('ssh_key') end
end
