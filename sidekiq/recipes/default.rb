#
# Cookbook:: sidekiq
# Recipe:: default
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

deploy_user = node.run_state[:deploy_user]
deploy_group = node.run_state[:deploy_group]
bundle_path = node.run_state[:bundle_path]

app = search(:aws_opsworks_app).first
app_path = "/srv/www/#{app['shortname']}"

template '/etc/systemd/system/sidekiq.service' do
  mode '0644'
  source 'sidekiq.service.erb'
  helper(:deploy_user) { deploy_user }
  helper(:deploy_group) { deploy_group }
  helper(:bundle_path) { bundle_path }
  helper(:app_path) { app_path }
  notifies :run, 'execute[daemon-reload]', :immediately
end

execute 'daemon-reload' do
  command 'systemctl daemon-reload'
  action :nothing
end

service 'sidekiq' do
  supports reload: true, restart: true, status: true
  action %i[enable restart]
end
