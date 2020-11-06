#
# Cookbook:: deploy
# Recipe:: rails
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

deploy_user = node.run_state[:deploy_user]
deploy_group = node.run_state[:deploy_group]
deploy_home = node.run_state[:deploy_home]

app = search(:aws_opsworks_app).first
app_path = "/srv/www/#{app['shortname']}"

if node['bundle'] && node['bundle']['config']
  node['bundle']['config'].each do |config|
    execute "Bundle Config: #{config['key']}" do
      cwd app_path
      user deploy_user
      group deploy_group
      command "bundle config --local #{config['key']} #{config['value']}"
      environment 'HOME' => deploy_home
    end
  end
end

execute 'Bundle install' do
  cwd app_path
  user deploy_user
  group deploy_group
  command 'bundle install --deployment --without development test'
  environment 'HOME' => deploy_home
end

execute 'Yarn install' do
  cwd app_path
  user deploy_user
  group deploy_group
  command 'yarn install --check-files'
  environment 'HOME' => deploy_home
end

# TODO: database.yml

# TODO: application.yml

execute 'Migrate database' do
  cwd app_path
  user deploy_user
  group deploy_group
  command 'bundle exec rake db:migrate'
  environment environment 'HOME' => deploy_home, 'RAILS_ENV' => 'production'
end

execute 'Assets precompile' do
  cwd app_path
  user deploy_user
  group deploy_group
  command 'bundle exec rake assets:precompile'
  environment environment 'HOME' => deploy_home, 'RAILS_ENV' => 'production'
end

# TODO: Upload assets to S3 bucket
