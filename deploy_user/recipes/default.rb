#
# Cookbook:: deploy_user
# Recipe:: default
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

app = search(:aws_opsworks_app).first
aws_users = search(:aws_opsworks_user)

group node['deploy_user']['group']

user node['deploy_user']['user'] do
  gid node['deploy_user']['group']
  shell '/bin/bash'
  manage_home true
end

directory '~/.ssh' do
  owner node['deploy']['user']
  group node['deploy']['group']
  recursive true
  mode '0700'
end

template '~/.ssh/authorized_keys' do
  source 'authorized_keys.erb'
  owner node['deploy_user']['user']
  group node['deploy_user']['group']
  helper(:aws_users) { aws_users }
end

file '~/.ssh/id_rsa' do
  action :create
  owner node['deploy_user']['user']
  group node['deploy_user']['group']
  content app['app_source']['ssh_key']
  mode '0600'
  only_if do app['app_source'].has_key?('ssh_key') end
end
