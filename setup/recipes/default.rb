#
# Cookbook:: setup
# Recipe:: default
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

swap_file '/mnt/swap' do
  size node['swap']['size'] # MBs
end

apt_update 'update'

apt_package 'libpq-dev'

apt_package 'postgresql-client'

apt_package 'libcurl4-gnutls-dev'
