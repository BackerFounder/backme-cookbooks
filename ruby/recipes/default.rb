#
# Cookbook:: ruby
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

apt_update 'update'

rbenv_system_install ''
rbenv_ruby node['ruby']['version']
rbenv_global node['ruby']['version']

template '/tmp/add_gem_path.sh' do
  source 'add_gem_path.sh.erb'
  owner 'root'
  group 'root'
end

execute 'Append script for adding gem path in /etc/profile.d/rbenv.sh' do
  user 'root'
  group 'root'
  command 'cat tmp/add_gem_path.sh >> /etc/profile.d/rbenv.sh'
  not_if 'grep $(gem env GEM_PATH) /etc/profile.d/rbenv.sh'
end

ruby_block 'Check Ruby is installed and get the current version' do
  block do
    Chef::Log.info("The current Ruby version is #{shell_out('source /etc/profile && ruby -v', user: node['ruby']['user']).stdout}")
    Chef::Log.info("The current RubyGem version is #{shell_out('source /etc/profile && gem -v', user: node['ruby']['user']).stdout}")
  end
end

