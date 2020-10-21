#
# Cookbook:: nginx
# Recipe:: setup
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

#app = search(:aws_opsworks_app).first
#app_path = "/srv/www/#{app['shortname']}

package 'nginx' do
  retries 3
  retry_delay 5
end

directory '/etc/nginx' do
  owner 'root'
  group 'root'
  mode 0755
end

%w{sites-available sites-enabled conf.d}.each do |dir|
  directory "/etc/nginx#{dir}" do
    owner 'root'
    group 'root'
    mode '0755'
  end
end

file '/etc/nginx/sites-enabled/default' do
  owner 'root'
  group 'root'
  action :delete
end

directory node['nginx']['log_dir'] do
  mode 0755
  owner node['nginx']['user']
  group node['nginx']['group']
  action :create
end

template '/etc/nginx/nginx.conf' do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action :nothing
end


