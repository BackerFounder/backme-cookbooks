#
# Cookbook:: cloud_watch
# Recipe:: delete_disk_used_percent_alarm
#
# Copyright:: 2021, BackerFounder, All Rights Reserved.

deploy_user = node.run_state[:deploy_user]
deploy_group = node.run_state[:deploy_group]

app = search(:aws_opsworks_app).first
instance = search(:aws_opsworks_instance, 'self:true').first
stack = search(:aws_opsworks_stack).first

alarm_name = "#{stack['name']} #{instance['hostname']} disk_free_percent more than #{node['cloud_watch']['disk_used_percent']['threshold']}%"

execute "delete disk_used_percent alarm: #{alarm_name}" do
  user deploy_user
  group deploy_group
  command "aws cloudwatch delete-alarms --alarm-names \
  \"#{alarm_name}\" \
  --region #{node['cloud_watch']['aws_region']}"
end
