#
# Cookbook:: deploy
# Recipe:: setup
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

# resync package index
apt_update 'update' do
  action :nothing
end

# gem `curb` uses libcurl
apt_package 'libcurl4-gnutls-dev' do
  notifies :update, 'apt_update[update]', :before
end

# gem `pg` uses libpq
apt_package 'libpq-dev'

# gem `ovirt-engine-sdk` uses libxml2
apt_package 'libxml2-dev'

# upload public assets & packs to s3
apt_package 'awscli'
