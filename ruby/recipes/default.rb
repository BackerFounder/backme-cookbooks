#
# Cookbook:: ruby
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

rbenv_system_install ''
rbenv_ruby node['ruby']['version']
rbenv_global node['ruby']['version']

include_recipe 'ruby::pass_vars'
