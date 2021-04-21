#
# Cookbook:: deploy
# Recipe:: rails
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

deploy_user = node.run_state[:deploy_user]
deploy_group = node.run_state[:deploy_group]
deploy_home = node.run_state[:deploy_home]
bundle_path = node.run_state[:bundle_path]
rails_env = node.run_state[:rails_env]

app = search(:aws_opsworks_app).first
app_path = "/srv/www/#{app['shortname']}"
rds = search(:aws_opsworks_rds_db_instance).first

directory "#{app_path}/tmp" do
  owner deploy_user
  group deploy_group
end

directory "#{app_path}/tmp/cache" do
  owner deploy_user
  group deploy_group
end

if node['bundle'] && node['bundle']['config']
  node['bundle']['config'].each do |config|
    execute "Bundle Config: #{config['key']}" do
      cwd app_path
      user deploy_user
      group deploy_group
      command "#{bundle_path} config --local #{config['key']} #{config['value']}"
      environment 'HOME' => deploy_home
    end
  end
end

execute 'Bundle install' do
  cwd app_path
  user deploy_user
  group deploy_group
  command "#{bundle_path} install --deployment --without development test"
  environment 'HOME' => deploy_home
end

execute 'Yarn install' do
  cwd app_path
  user deploy_user
  group deploy_group
  command 'yarn install --check-files'
  environment 'HOME' => deploy_home
end

template "#{app_path}/config/database.yml" do
  source 'database.yml.erb'
  owner deploy_user
  group deploy_group
  mode '0744'
  helper(:rds) { rds }
end

file "#{app_path}/config/application.yml" do
  content node['deploy']['application_yml'].to_h.to_yaml
  mode '0744'
  owner deploy_user
  group deploy_group
end


execute "Migrate database: rake #{node['deploy']['migrate_rake']}" do
  cwd app_path
  user deploy_user
  group deploy_group
  command "#{bundle_path} exec rake #{node['deploy']['migrate_rake']}"
  environment environment 'HOME' => deploy_home, 'RAILS_ENV' => rails_env
end


execute 'Assets precompile' do
  cwd app_path
  user deploy_user
  group deploy_group
  command "#{bundle_path} exec rake assets:precompile"
  environment environment 'HOME' => deploy_home, 'RAILS_ENV' => rails_env
end

if rails_env == 'production'
  execute "Upload assets to S3 bucket" do
    cwd app_path
    user deploy_user
    group deploy_group
    command "aws s3 sync \
      #{::File.join('public', node['deploy']['public_output_path'], 'assets')} \
      #{::File.join(node['deploy']['s3_asset_path'], 'assets')} \
      --cache-control max-age=31536000,public \
      --acl public-read"
  end

  execute "Upload packs to S3 bucket" do
    cwd app_path
    user deploy_user
    group deploy_group
    command "aws s3 sync \
      #{::File.join('public', node['deploy']['public_output_path'], 'packs')} \
      #{::File.join(node['deploy']['s3_asset_path'], 'packs')} \
      --exclude '*.map' \
      --exclude 'manifest.json*' \
      --cache-control max-age=31536000,public \
      --acl public-read"
  end
end
