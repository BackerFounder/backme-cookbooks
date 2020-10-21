#
# Cookbook:: unicorn
# Recipe:: setup
#
# Copyright:: 2020, The Authors, All Rights Reserved.

# resource `gem_package` in Chef 12 do not support Ruby 2.6.0 and options `--no-rdoc --no-ri` are hard coded.
# For more infomation, see: https://github.com/chef/chef/issues/8416
app = search(:aws_opsworks_app).first
app_path = "/srv/www/#{app['shortname']}"

%w{config pids sockets log}.each do |dir|
  directory File.join(app_path, 'shared', dir) do
    owner node['unicorn']['user']
    group node['unicorn']['group']
    recursive true
    mode '0755'
  end
end

template File.join(app_path, 'shared', 'config', 'unicorn.rb') do
  source 'unicorn.rb.erb'
  owner node['unicorn']['user']
  group node['unicorn']['group']
  helper(:app_path) { app_path }
  mode '0744'
end

template '/etc/systemd/system/unicorn@.service' do
  source 'unicorn.service.erb'
  owner 'root'
  group 'root'
  helper(:app_path) { app_path }
  helper(:bundle_path){ node['unicorn']['bundle_path'] }
end
