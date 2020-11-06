#
# Cookbook:: ruby
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

ruby_block 'Check Bundler exist and store bundle path in run state' do
  block do
    bundle_path = shell_out('which bundle').stdout
    raise 'Could not find bundle' if bundle_path.nil? || bundle_path.empty?
    node.run_state[:bundle_path] = bundle_path
  end
end
