#
# Cookbook:: ruby
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

rbenv_system_install ''
rbenv_ruby node['ruby']['version']
rbenv_global node['ruby']['version']

include_recipe 'ruby::pass_vars'

ruby_block 'Debug: check rbenv' do
  block do
    Chef::Log.info("Ruby version is #{shell_out('ruby -v').stdout}")
    Chef::Log.info("Ruby path is #{shell_out('which ruby').stdout}")
  end
end
