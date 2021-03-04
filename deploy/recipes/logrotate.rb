#
# Cookbook:: deploy
# Recipe:: logrotate
#
# Copyright:: 2021, BackerFounder, All Rights Reserved.

app = search(:aws_opsworks_app).first
app_path = "/srv/www/#{app['shortname']}"

logrotate_app 'rails' do
  path "#{app_path}/log/*.log"
  frequency node['deploy']['logrotate_frequency']
  options node['deploy']['logrotate_options']
  rotate node['deploy']['logrotate_days']
end
