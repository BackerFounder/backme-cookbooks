#
# Cookbook:: nginx
# Recipe:: unicorn_config
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

app = search(:aws_opsworks_app).first
app_shortname = app['shortname']
app_path = "/srv/www/#{app_shortname}"

%w{sites-available sites-enabled}.each do |dir|
  template "/etc/nginx/#{dir}/#{app_shortname}" do
    source 'nginx_unicorn.conf.erb'
    owner 'root'
    group 'root'
    mode 0644
    helper(:app_shortname) { app_shortname }
    helper(:app_path) { app_path }
  end
end


