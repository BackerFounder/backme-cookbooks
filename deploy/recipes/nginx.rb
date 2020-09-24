#
# Cookbook:: deploy
# Recipe:: nginx
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

package "nginx" do
  retries 3
  retry_delay 5
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action :nothing
end
