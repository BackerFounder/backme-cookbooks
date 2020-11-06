#
# Cookbook:: node
# Recipe:: default
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

apt_repository 'node.js' do
  uri node['node']['repo']
  components ['main']
  keyserver node['node']['keyserver']
  key node['node']['key']
end

package 'nodejs'

ruby_block 'Check Node.js is installed and get the current version' do
  block do
    Chef::Log.info("The current Node.js version is #{shell_out('node -v').stdout}")
  end
end
