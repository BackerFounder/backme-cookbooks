#
# Cookbook:: alb_support
# Recipe:: shutdown
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

stack = search("aws_opsworks_stack").first
stack_region = stack[:region]
instance = search("aws_opsworks_instance", "self:true").first
ec2_instance_id = instance[:ec2_instance_id]

target_group_arn = node[:alb_support][:target_group_arn]
connection_draining_timeout = node[:alb_support][:connection_draining_timeout]
state_check_frequency = node[:alb_support][:state_check_frequency]

ruby_block "detach from ALB" do
  block do
    require "aws-sdk-core"

    Chef::Log.info("Creating ELB client in region #{stack_region}")
    client = Aws::ElasticLoadBalancingV2::Client.new(region: stack_region)

    target_to_detach = {
      target_group_arn: target_group_arn,
      targets: [ { id: ec2_instance_id } ],
    }

    Chef::Log.info("Deregistering EC2 instance #{ec2_instance_id} from Target Group #{target_group_arn}")
    client.deregister_targets(target_to_detach)

    if connection_draining_timeout == 0
      Chef::Log.info("connection_draining_timeout was set to 0 seconds. execution of shutdown recipes will not be delayed")
      return
    end

    Chef::Log.info("delaying execution recipes until instance is drained from ALB or timeout of #{connection_draining_timeout} seconds elapses")
    start_time = Time.now
    loop do
      response = client.describe_target_health(target_to_detach)
      target_health_state = response[:target_health_descriptions].first[:target_health][:state]
      Chef::Log.info("state of instance in ALB: #{target_health_state}")
      seconds_elapsed = Time.now - start_time
      Chef::Log.info("#{seconds_elapsed} of a maximum #{connection_draining_timeout} seconds elapsed")
      Chef::Log.info("Sleeping #{ state_check_frequency} seconds")
      break if target_health_state == "unused" || seconds_elapsed > connection_draining_timeout
      sleep(state_check_frequency)
    end
  end
  action :run
end


