#
# Cookbook:: deploy
# Recipe:: deploy
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.
require 'yaml'
app = search(:aws_opsworks_app).first
app_path = "/srv/www/#{app['shortname']}"
rds = search(:aws_opsworks_rds_db_instance).first

raise "Unsupported app_source type: #{app['app_source']['type']}" unless app['app_source']['type'] == 'git'

include_recipe 'deploy::add_known_host'
include_recipe 'deploy::add_rsa_keys'
include_recipe 'deploy::sync_repo'
include_recipe 'deploy::purge_old_releases'

bash 'Bundle install' do
  cwd File.join(app_path, 'current')
  user 'root'
  group 'root'
  code <<-EOH
    source /etc/profile
    bundle install --deployment --frozen
  EOH
  environment 'RAILS_ENV' => 'production'
end

bash 'Install JS dependencies' do
  cwd File.join(app_path, 'current')
  user 'root'
  group 'root'
  code <<-EOH
    source /etc/profile
    yarn install --check-files
  EOH
end

template File.join(app_path, 'current', 'config', 'database.yml') do
  source 'database.yml.erb'
  owner node['deploy']['user']
  group node['deploy']['group']
  mode '0744'
  helper(:rds) { rds }
end

file File.join(app_path, 'current', 'config', 'application.yml') do
  content node['deploy']['environment_variables'].to_h.to_yaml
  mode '0744'
  owner node['deploy']['user']
  group node['deploy']['group']
end

bash 'Migrate database' do
  cwd File.join(app_path, 'current')
  user node['deploy']['user']
  group node['deploy']['group']
  code <<-EOH
    source /etc/profile
    bundle exec rake db:migrate
  EOH
  environment 'RAILS_ENV' => 'production'
end

bash 'Assets precompile' do
  cwd File.join(app_path, 'current')
  user node['deploy']['user']
  group node['deploy']['group']
  code <<-EOH
    source /etc/profile
    bundle exec rake assets:precompile
  EOH
  environment 'RAILS_ENV' => 'production',
              'HOME' => "/home/#{node['deploy']['home']}",
              'USER' => node['deploy']['user']
end


execute "Upload assets to S3 bucket" do
  cwd File.join(app_path, 'current')
  command "aws s3 sync \
#{::File.join('public', node['deploy']['public_output_path'], 'assets')} \
#{::File.join(node['deploy']['s3_asset_path'], 'assets')} \
--cache-control max-age=31536000,public \
--acl public-read"
end

execute "Upload packs to S3 bucket" do
  cwd File.join(app_path, 'current')
  command "aws s3 sync \
#{::File.join('public', node['deploy']['public_output_path'], 'packs')} \
#{::File.join(node['deploy']['s3_asset_path'], 'packs')} \
--exclude '*.map' \
--exclude 'manifest.json*' \
--cache-control max-age=31536000,public \
--acl public-read"
end
