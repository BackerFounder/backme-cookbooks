#
# Cookbook:: node
# Recipe:: default
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

case node['platform_family']
when 'debian'
  bash 'Add the signing key and desired repo' do
    cwd '/tmp'
    code <<-EOH
    curl -sS #{node['yarn']['package']['key']} | sudo apt-key add -
    echo "deb #{node['yarn']['package']['uri']} #{node['yarn']['package']['distribution']} main" | sudo tee /etc/apt/sources.list.d/yarn.list
    EOH
  end

  apt_update 'update'

  apt_package 'yarn'
else
  raise "Unsupported platform: #{node['platform']}"
end
