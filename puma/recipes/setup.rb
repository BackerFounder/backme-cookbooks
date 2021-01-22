#
# Cookbook:: puma
# Recipe:: setup
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

deploy_user = node.run_state[:deploy_user]
bundle_path = node.run_state[:bundle_path]
rails_env = node.run_state[:rails_env]
serve_static_files = node[:puma][:serve_static_files].to_s.downcase == 'true'

app = search(:aws_opsworks_app).first
app_path = "/srv/www/#{app['shortname']}"

template "/etc/systemd/system/puma.service" do
  source 'puma.service.erb'
  helper(:app_path) { app_path }
  helper(:bundle_path) { bundle_path }
  helper(:deploy_user) { deploy_user }
  helper(:rails_env) { rails_env }
  helper(:serve_static_files){ serve_static_files }
end
