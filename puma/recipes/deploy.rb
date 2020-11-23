#
# Cookbook:: puma
# Recipe:: deploy
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

deploy_user = node.run_state[:deploy_user]
deploy_group = node.run_state[:deploy_group]

app = search(:aws_opsworks_app).first
app_path = "/srv/www/#{app['shortname']}"

%w{pids sockets}.each do |dir|
  directory "#{app_path}/tmp/#{dir}" do
    owner deploy_user
    group deploy_group
    recursive true
  end
end

systemd_unit 'puma' do
  content '/etc/systemd/system/puma.service'
  action :reload_or_restart
end