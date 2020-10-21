#
# Cookbook:: unicorn
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

# resource `gem_package` in Chef 12 do not support Ruby 2.6.0 and options `--no-rdoc --no-ri` are hard coded.
# For more infomation, see: https://github.com/chef/chef/issues/8416

rbenv_script "Install unicorn" do
  user 'root'
  group 'root'
  code "gem install unicorn -N -v #{node['ruby']['unicorn_version']}"
end

rbenv_script "Install rack" do
  user 'root'
  group 'root'
  code "gem install rack -N -v #{node['ruby']['rack_version']}"
end

