#
# Cookbook:: deploy
# Recipe:: add_rsa_keys
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.


app = search(:aws_opsworks_app).first

file '~/.ssh/id_rsa' do
  action :create
  owner node['deploy']['user']
  group node['deploy']['group']
  content app['app_source']['ssh_key']
  mode '0600'
  only_if do app['app_source'].has_key?('ssh_key') end
end


