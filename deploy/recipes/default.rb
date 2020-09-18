#
# Cookbook:: deploy
# Recipe:: default
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

include_recipe 'deploy::add_known_host'
include_recipe 'deploy::add_rsa_keys'
include_recipe 'deploy::sync_repo'
