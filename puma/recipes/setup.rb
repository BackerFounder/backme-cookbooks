#
# Cookbook:: puma
# Recipe:: setup
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

deploy_user = node.run_state[:deploy_user]
bundle_path = node.run_state[:bundle_path]

app = search(:aws_opsworks_app).first
app_path = "/srv/www/#{app['shortname']}"

template "/etc/systemd/system/puma.service" do
  source 'puma.service.erb'
  helper(:app_path) { app_path }
  helper(:bundle_path) { bundle_path }
  helper(:deploy_user) { deploy_user }
end
