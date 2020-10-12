#
# Cookbook:: deploy
# Recipe:: sync_repo
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

app = search(:aws_opsworks_app).first
app_path = "/srv/www/#{app['shortname']}"

Chef::Log.info("The current aws_opsworks_app app_path: #{app_path}")

directory app_path do
  owner 'root'
  mode 0755
  recursive true
end

execute "chown the app folder (#{app_path}) to deploy user: #{node['deploy']['user']}" do
  user 'root'
  group 'root'
  command "chown #{node['deploy']['user']}: #{app_path}"
end

git 'Sync Backme repository' do
  user node['deploy']['user']
  group node['deploy']['group']
  repository app['app_source']['url']
  revision app['app_source']['revision']
  destination app_path
end
