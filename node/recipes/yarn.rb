#
# Cookbook:: node
# Recipe:: default
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

case node['platform_family']
when 'debian'
  # Ubuntu 17.04 comes with cmdtest installed by default. Remove it to prevent
  # getting errors from installing yarn.
  # https://github.com/yarnpkg/yarn/issues/2821
  # apt_package 'cmdtest' do
  #   action 'remove'
  # end

  bash 'Add the signing key and desired repo' do
    cwd '/tmp'
    code <<-EOH
    sudo apt-get remove cmdtest -y
    curl -sS #{node['yarn']['package']['key']} | sudo apt-key add -
    echo "deb #{node['yarn']['package']['uri']} #{node['yarn']['package']['distribution']} main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt-get update
    sudo apt-get install yarn -y
    EOH
  end

  # apt_update 'update'

  # apt_package 'yarn' do
  #   options '--no-install-recommends'
  # end
else
  raise "Unsupported platform: #{node['platform']}"
end
