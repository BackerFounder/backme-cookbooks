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
  home "/home/#{node['deploy_user']['home']}"
  shell '/bin/bash'
  manage_home true
end

# directory "/home/#{node['deploy_user']['home']}" do
#   owner node['deploy_user']['user']
#   group node['deploy_user']['group']
#   recursive true
#   mode '0755'
# end

directory File.join('home', node['deploy_user']['home'], '.ssh') do
  owner node['deploy_user']['user']
  group node['deploy_user']['group']
  mode '0700'
end

template File.join('home', node['deploy_user']['home'], '.ssh/authorized_keys') do
  source 'authorized_keys.erb'
  owner node['deploy_user']['user']
  group node['deploy_user']['group']
  helper(:aws_users) { aws_users }
end

file File.join('home', node['deploy_user']['home'], '.ssh/id_rsa') do
  action :create
  owner node['deploy_user']['user']
  group node['deploy_user']['group']
  content app['app_source']['ssh_key']
  mode '0600'
  only_if do app['app_source'].has_key?('ssh_key') end
end

template File.join('etc','sudoers.d', node['deploy_user']['user']) do
  source 'sudoers.d.erb'
  owner 'root'
  group 'root'
  helper(:user) { node['deploy_user']['user'] }
  mode '0440'
end
