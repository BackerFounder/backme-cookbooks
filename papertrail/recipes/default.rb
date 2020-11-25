#
# Cookbook:: papertrail
# Recipe:: default
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

full_pkg_name = "remote-syslog2_#{node['papertrail']['version']}_amd64.deb"

remote_file "#{Chef::Config[:file_cache_path]}/#{full_pkg_name}" do
  source "https://github.com/papertrail/remote_syslog2/releases/download/v#{node['papertrail']['version']}/#{full_pkg_name}"
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

dpkg_package 'remote-syslog2' do
  action :install
  source "#{Chef::Config[:file_cache_path]}/#{full_pkg_name}"
end

template '/etc/log_files.yml' do
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    files: node['papertrail']['files'],
    destination_host: node['papertrail']['destination_host'],
    destination_port: node['papertrail']['destination_port'],
    destination_protocol: node['papertrail']['destination_protocol'],
    exclude_files: node['papertrail']['exclude_files'],
    hostname: node['papertrail']['hostname'],
    exclude_patterns: node['papertrail']['exclude_patterns'],
    new_file_check_interval: node['papertrail']['new_file_check_interval'],
    facility: node['papertrail']['facility'],
    severity: node['papertrail']['severity']
  )
  notifies :restart, 'service[remote_syslog]', :delayed
end

service 'remote_syslog' do
  action [:start, :enable]
  provider Chef::Provider::Service::Systemd
  subscribes :restart, 'dpkg_package[remote-syslog2]', :delayed
end

