#
# Cookbook:: whenever
# Recipe:: default
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

deploy_user = node.run_state[:deploy_user]
deploy_group = node.run_state[:deploy_group]
bundle_path = node.run_state[:bundle_path]

app = search(:aws_opsworks_app).first
app_path = "/srv/www/#{app['shortname']}"

execute 'whenever update-crontab' do
  cwd app_path
  user deploy_user
  group deploy_group
  command "#{bundle_path} exec whenever --set environment=#{node[:deploy][:rails_env]} --update-crontab"
  only_if "cd #{app_path} && #{bundle_path} show whenever"
end
