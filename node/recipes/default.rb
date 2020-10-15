#
# Cookbook:: node
# Recipe:: default
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

directory node['nodejs']['nvm_dir'] do
  user 'root'
  group 'root'
  recursive true
  mode '0755'
end

directory File.join('/home', node['nodejs']['home'], '.config') do
  owner node['nodejs']['user']
  group node['nodejs']['group']
  mode '0744'
end

template '/etc/profile.d/nvm.sh' do
  user 'root'
  group 'root'
  source 'nvm.sh.erb'
  mode 0755
  helper(:nvm_dir) { node['nodejs']['nvm_dir'] }
end

# helper(:nodejs_version) { node['nodejs']['version'] }

bash 'Install nvm' do
  user 'root'
  group 'root'
  code <<-EOH
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/#{node['nodejs']['nvm_version']}/install.sh | bash
    source /etc/profile.d/nvm.sh
    nvm install #{node['nodejs']['version']}
    chown -R $USER:$(id -gn $USER) $HOME/.config
  EOH
  environment 'HOME' => "/home/#{node['nodejs']['home']}",
              'USER' => node['nodejs']['user'],
              'NVM_DIR' => node['nodejs']['nvm_dir']
end

include_recipe 'node::yarn'

ruby_block 'Check Yarn is installed and get the current version' do
  block do
    Chef::Log.info("The current Node.js version is #{shell_out('node -v', user: node['nodejs']['user']).stdout}")
    Chef::Log.info("The current Yarn version is #{shell_out('yarn -v', user: node['nodejs']['user']).stdout}")
  end
end
