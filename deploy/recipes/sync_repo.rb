#
# Cookbook:: deploy
# Recipe:: sync_repo
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

deploy_user = node.run_state[:deploy_user]
deploy_group = node.run_state[:deploy_group]
deploy_home = node.run_state[:deploy_home]

app = search(:aws_opsworks_app).first
app_path = "/srv/www/#{app['shortname']}"

Chef::Log.info("The current aws_opsworks_app app_path: #{app_path}")

directory app_path do
  owner deploy_user
  group deploy_group
  recursive true
end

git 'Sync Backme repository' do
  user deploy_user
  group deploy_group
  repository app['app_source']['url']
  revision app['app_source']['revision']
  destination app_path
end
