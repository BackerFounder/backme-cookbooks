#
# Cookbook:: deploy_user
# Recipe:: pass_vars
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

node.run_state[:deploy_user] = node['deploy_user']['user']
node.run_state[:deploy_group] = node['deploy_user']['group']
node.run_state[:deploy_home] = "/home/#{node['deploy_user']['user']}"
