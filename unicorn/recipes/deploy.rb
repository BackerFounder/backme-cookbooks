#
# Cookbook:: unicorn
# Recipe:: deploy
#
# Copyright:: 2020, The Authors, All Rights Reserved.
app = search(:aws_opsworks_app).first
app_path = "/srv/www/#{app['shortname']}"

service "unicorn@1" do
  action :start
end
