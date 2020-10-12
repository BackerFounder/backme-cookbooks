#
# Cookbook:: deploy
# Recipe:: deploy
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

app = search(:aws_opsworks_app).first
app_path = "/srv/www/#{app['shortname']}"

raise "Unsupported app_source type: #{app['app_source']['type']}" unless app['app_source']['type'] == 'git'

include_recipe 'deploy::add_known_host'
include_recipe 'deploy::add_rsa_keys'
include_recipe 'deploy::sync_repo'

execute 'bundle install' do
  cwd app_path
  command 'bundle install --deployment --frozen'
end

# ----- create unicorn.rb & start unicorn

template File.join(app_path, 'config', 'unicorn.rb') do
  source 'unicorn.rb.erb'
  owner node['deploy']['user']
  group node['deploy']['group']
  helper(:app_path) { app_path }
end

directory File.join(app_path, 'shared', 'pids') do
  owner node['deploy']['user']
  group node['deploy']['group']
  recursive true
  mode '0700'
end

directory File.join(app_path, 'shared', 'socket') do
  owner node['deploy']['user']
  group node['deploy']['group']
  recursive true
  mode '0700'
end

directory File.join(app_path, 'shared', 'log') do
  owner node['deploy']['user']
  group node['deploy']['group']
  recursive true
  mode '0700'
end

execute 'Install JS dependencies' do
  user node['deploy']['user']
  group node['deploy']['group']
  cwd app_path
  command "yarn install --check-files"
end

execute 'Run unicorn as daemon' do
  user node['deploy']['user']
  group node['deploy']['group']
  cwd app_path
  command "bundle exec unicorn -c #{File.join(app_path, 'config', 'unicorn.rb')} -D"
end

# execute 'run unicorn_rails' do
#   command "unicorn_rails -c #{File.join(conf_path, 'unicorn.rb')} -D"
# end
