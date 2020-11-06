#
# Cookbook:: node
# Recipe:: default
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

execute 'Install yarn' do
  command 'npm install -g yarn'
end

ruby_block 'Check Yarn is installed and get the current version' do
  block do
    Chef::Log.info("The current Yarn version is #{shell_out('yarn -v').stdout}")
  end
end
