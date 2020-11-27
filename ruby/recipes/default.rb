#
# Cookbook:: ruby
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

rbenv_system_install ''
rbenv_ruby node['ruby']['version']
rbenv_global node['ruby']['version']

include_recipe 'ruby::pass_vars'

template '/etc/profile.d/path.sh' do
  source 'path.sh.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

ruby_block 'Check Ruby version' do
  block do
    command = "#{node.run_state[:ruby_path]} -v"
    Chef::Log.info("Ruby version is #{shell_out(command).stdout}")
  end
end
