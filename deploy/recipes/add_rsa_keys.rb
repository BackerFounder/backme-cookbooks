#
# Cookbook:: deploy
# Recipe:: add_rsa_keys
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

deploy_user = node.run_state[:deploy_user]
deploy_group = node.run_state[:deploy_group]
deploy_home = node.run_state[:deploy_home]


app = search(:aws_opsworks_app).first

file "#{deploy_home}/.ssh/id_rsa" do
  action :create
  owner deploy_user
  group deploy_group
  content app['app_source']['ssh_key']
  mode '0600'
  only_if do app['app_source'].has_key?('ssh_key') end
end


