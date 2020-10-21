#
# Cookbook:: deploy
# Recipe:: sync_repo
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

app = search(:aws_opsworks_app).first
app_path = "/srv/www/#{app['shortname']}"
current_release = Time.now.utc.strftime('%Y%m%d%H%M%S')

Chef::Log.info("The current aws_opsworks_app app_path: #{app_path}")

directory File.join(app_path, 'releases', current_release) do
  owner 'root'
  mode 0755
  recursive true
end

execute "chown the app folder (#{app_path}) to deploy user: #{node['deploy']['user']}" do
  user 'root'
  group 'root'
  command "chown -R #{node['deploy']['user']} #{app_path}"
end

link File.join(app_path, 'current') do
  to File.join(app_path, 'releases', current_release)
  owner node['deploy']['user']
  group node['deploy']['group']
end

git 'Sync Backme repository' do
  user node['deploy']['user']
  group node['deploy']['group']
  repository app['app_source']['url']
  revision app['app_source']['revision']
  destination "#{app_path}/current"
end
