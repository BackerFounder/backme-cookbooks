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

directory File.join('home', node['nodejs']['home'], '.config') do
  owner node['nodejs']['user']
  group node['nodejs']['group']
  mode '0700'
end

bash 'Install nvm' do
  user 'root'
  group 'root'
  code <<-EOH
    export NVM_DIR=#{node['nodejs']['nvm_dir']}
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/#{node['nodejs']['nvm_version']}/install.sh | bash
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm install #{node['nodejs']['version']}
    export PATH=$PATH:#{node['nodejs']['nvm_dir']}/versions/node/#{node['nodejs']['version']}/bin
  EOH
  environment ({'HOME' => "home/#{node['nodejs']['home']}", 'USER' => node['nodejs']['user']})
end

template '/etc/profile.d/nvm.sh' do
  user 'root'
  group 'root'
  source 'nvm.sh.erb'
  mode 0755
  helper(:nvm_dir) { node['nodejs']['nvm_dir'] }
  helper(:nodejs_version) { node['nodejs']['version'] }
end

bash 'source nvm.sh' do
  user node['nodejs']['user']
  group node['nodejs']['group']
  code <<-EOH
    source /etc/profile
  EOH
  environment ({'HOME' => "home/#{node['nodejs']['home']}", 'USER' => node['nodejs']['user']})
end

include_recipe 'node::yarn'

ruby_block 'Check Yarn is installed and get the current version' do
  block do
    Chef::Log.info("The current Node.js version is #{shell_out('source /etc/profile && node -v', user: node['nodejs']['user']).stdout}")
    Chef::Log.info("The current Yarn version is #{shell_out('yarn -v', user: node['nodejs']['user']).stdout}")
  end
end

bash 'check' do
  user node['nodejs']['user']
  group node['nodejs']['group']
  code <<-EOH
    node -v
  EOH
  environment ({'HOME' => "home/#{node['nodejs']['home']}", 'USER' => node['nodejs']['user']})
end
