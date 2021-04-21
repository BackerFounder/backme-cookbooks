#
# Cookbook:: cloud_watch
# Recipe:: install_cwagent
#
# Copyright:: 2021, BackerFounder, All Rights Reserved.

deploy_user = node.run_state[:deploy_user]
deploy_group = node.run_state[:deploy_group]
deploy_home = node.run_state[:deploy_home]

aws_path = ::File.join(deploy_home, '.aws')
config_json_path = '/opt/aws/amazon-cloudwatch-agent/bin/config.json'

apt_update 'update' do
  action :nothing
end

apt_package 'collectd'

remote_file '/tmp/amazon-cloudwatch-agent.deb' do
  source node['cloud_watch']['cwagent_deb_url']
end

dpkg_package 'amazon-cloudwatch-agent' do
  options '-E'
  source '/tmp/amazon-cloudwatch-agent.deb'
  action :install
end

template config_json_path do
  source 'config.json.erb'
  owner deploy_user
  group deploy_group
end

template '/opt/aws/amazon-cloudwatch-agent/etc/common-config.toml' do
  source 'common-config.toml.erb'
  owner deploy_user
  group deploy_group
  helper(:credential_path) { ::File.join(aws_path, 'credentials') }
end

execute 'Start CloudWatch Agent' do
  user 'root'
  group 'root'
  command "/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:#{config_json_path} -s"
end
