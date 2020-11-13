#
# Cookbook:: ruby
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

bundle_path = '/usr/local/rbenv/shims/bundle'
gem_path = '/usr/local/rbenv/shims/gem'
ruby_path = '/usr/local/rbenv/shims/ruby'

ruby_block 'Check version of Ruby' do
  block do
    Chef::Log.info("Ruby version is #{shell_out("#{ruby_path} -v").stdout}")
  end
end

node.run_state[:bundle_path] = bundle_path
node.run_state[:gem_path] = gem_path
node.run_state[:ruby_path] = ruby_path
