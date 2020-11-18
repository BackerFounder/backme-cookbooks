#
# Cookbook:: nginx
# Recipe:: unicorn_config
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

app = search(:aws_opsworks_app).first
app_shortname = app['shortname']
app_path = "/srv/www/#{app_shortname}"

template "/etc/nginx/sites-available/default" do
  source 'nginx_puma.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  helper(:app_shortname) { app_shortname }
  helper(:app_path) { app_path }
end

link "/etc/nginx/sites-enabled/default" do
  to "/etc/nginx/sites-available/default"
  not_if { File.symlink?('/etc/nginx/sites-enabled/default') }
end
