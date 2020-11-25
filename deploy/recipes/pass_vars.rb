#
# Cookbook:: deploy
# Recipe:: pass_vars
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

node.run_state[:rails_env] = node['deploy']['rails_env']
