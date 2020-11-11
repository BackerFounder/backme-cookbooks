#
# Cookbook:: deploy
# Recipe:: setup
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

# resync package index
apt_update 'update'

# gem `curb` uses libcurl
apt_package 'libcurl4-gnutls-dev'

# gem `pg` uses libpq
apt_package 'libpq-dev'

# gem `ovirt-engine-sdk` uses libxml2
apt_package 'libxml2-dev'

include_recipe 'deploy::aws_cli'
