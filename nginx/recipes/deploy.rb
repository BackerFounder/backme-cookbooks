#
# Cookbook:: nginx
# Recipe:: deploy
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

systemd_unit 'nginx' do
  content '/etc/systemd/system/nginx.service'
  action :reload_or_restart
end
