#
# Cookbook:: cloud_watch
# Recipe:: disk_used_percent_alarm
#
# Copyright:: 2021, BackerFounder, All Rights Reserved.

deploy_user = node.run_state[:deploy_user]
deploy_group = node.run_state[:deploy_group]

app = search(:aws_opsworks_app).first
instance = search(:aws_opsworks_instance, 'self:true').first
stack = search(:aws_opsworks_stack).first

alarm_name = "#{stack['name']} #{instance['hostname']} disk_free_percent more than #{node['cloud_watch']['disk_used_percent']['threshold']}%"

execute "setup disk_used_percent alarm: #{alarm_name}" do
  user deploy_user
  group deploy_group
  command "aws cloudwatch put-metric-alarm \
    --alarm-name \"#{alarm_name}\" \
    --alarm-description \"#{alarm_name}\" \
    --namespace CWAgent \
    --metric-name disk_used_percent  \
    --statistic Average \
    --period 60 \
    --evaluation-periods 3 \
    --threshold #{node['cloud_watch']['disk_used_percent']['threshold']} \
    --comparison-operator GreaterThanThreshold \
    --dimensions \"Name=path,Value=/\" \
                 \"Name=InstanceId,Value=#{instance['ec2_instance_id']}\" \
                 \"Name=ImageId,Value=#{instance['ami_id']}\" \
                 \"Name=InstanceType,Value=#{instance['instance_type']}\" \
                 \"Name=device,Value=#{node['cloud_watch']['disk_used_percent']['device']}\" \
                 \"Name=fstype,Value=#{node['cloud_watch']['disk_used_percent']['fstype']}\" \
    --alarm-actions #{node['cloud_watch']['disk_used_percent']['alarm_actions_arn']} \
    --region #{node['cloud_watch']['aws_region']}"
end

