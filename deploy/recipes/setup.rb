#
# Cookbook:: deploy
# Recipe:: setup
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

app = search(:aws_opsworks_app).first
app_path = "/srv/www/#{app['shortname']}"

# -------- other packages

apt_update 'update'

apt_package 'libcurl4-openssl-dev'

apt_package 'libpq-dev'

apt_package 'postgresql-client'

# -------- nginx

package "nginx" do
  retries 3
  retry_delay 5
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action :nothing
end


