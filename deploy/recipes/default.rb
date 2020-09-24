#
# Cookbook:: deploy
# Recipe:: default
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

app = search(:aws_opsworks_app).first

raise "Unsupported app_source type: #{app['app_source']['type']}" unless app['app_source']['type'] == 'git'

include_recipe 'deploy::add_known_host'
include_recipe 'deploy::add_rsa_keys'
include_recipe 'deploy::sync_repo'
include_recipe 'deploy::nginx'
