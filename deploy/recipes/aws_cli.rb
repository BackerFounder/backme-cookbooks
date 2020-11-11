#
# Cookbook:: deploy
# Recipe:: aws_cli
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

execute 'unzip_awscliv2' do
  cwd '/tmp'
  user 'root'
  group 'root'
  command 'unzip -o /tmp/awscliv2.zip'
  action :nothing
  notifies :run,'execute[awscli_install]', :immediately
end

execute 'awscli_install' do
  user 'root'
  group 'root'
  command '/tmp/aws/install'
  action :nothing
end

remote_file '/tmp/awscliv2.zip' do
  source 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip'
  owner 'root'
  group 'root'
  action :create
  notifies :run, 'execute[unzip_awscliv2]', :immediately
  not_if 'which aws'
end