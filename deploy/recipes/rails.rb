#
# Cookbook:: deploy
# Recipe:: rails
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

deploy_user = node.run_state[:deploy_user]
deploy_group = node.run_state[:deploy_group]
deploy_home = node.run_state[:deploy_home]
bundle_path = node.run_state[:bundle_path]

app = search(:aws_opsworks_app).first
app_path = "/srv/www/#{app['shortname']}"
rds = search(:aws_opsworks_rds_db_instance).first

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

execute 'Migrate database' do
  cwd app_path
  user deploy_user
  group deploy_group
  command "#{bundle_path} exec rake db:migrate"
  environment environment 'HOME' => deploy_home, 'RAILS_ENV' => node['deploy']['rails_env']
end

execute 'Assets precompile' do
  cwd app_path
  user deploy_user
  group deploy_group
  command "#{bundle_path} exec rake assets:precompile"
  environment environment 'HOME' => deploy_home, 'RAILS_ENV' => node['deploy']['rails_env']
end

# TODO: Upload assets to S3 bucket