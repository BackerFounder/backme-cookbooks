#
# Cookbook:: setup
# Recipe:: default
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

swap_file '/mnt/swap' do
  size node['swap']['size'] # MBs
end
