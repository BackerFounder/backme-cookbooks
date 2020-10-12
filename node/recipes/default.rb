#
# Cookbook:: node
# Recipe:: default
#
# Copyright:: 2020, BackerFounder, All Rights Reserved.

directory node['nodejs']['nvm_dir'] do
  user node['nodejs']['user']
  group node['nodejs']['group']
  recursive true
  mode '0755'
end

directory File.join('home', node['deploy_user']['home'], '.config') do
  owner node['deploy_user']['user']
  group node['deploy_user']['group']
  mode '0700'
end

execute "Run script to install NVM #{node['nodejs']['nvm_version']} in #{node['nodejs']['nvm_dir']}" do
  user node['nodejs']['user']
  group node['nodejs']['group']
  command "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/#{node['nodejs']['nvm_version']}/install.sh | NVM_DIR=\"#{node['nodejs']['nvm_dir']}\" bash"
  environment ({'HOME' => node['nodejs']['home'], 'USER' => node['nodejs']['user']})
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
    sudo chown -R $USER:$(id -gn $USER) home/deploy/.config
    node -v
    whoami
  EOH
  environment ({'HOME' => node['nodejs']['home'], 'USER' => node['nodejs']['user']})
end

# include_recipe "node::yarn"

# execute "NVM use node version: #{node['nodejs']['version']}" do
#   user node['nodejs']['user']
#   group node['nodejs']['group']
#   command "nvm use #{node['nodejs']['version']}"
# end

execute 'check' do
  user node['nodejs']['user']
  group node['nodejs']['group']
  command 'node -v'
  environment ({'HOME' => node['nodejs']['home'], 'USER' => node['nodejs']['user']})
end

# ruby_block 'Check Yarn is installed and get the current version' do
#   block do
#     Chef::Log.info("The current Node.js version is #{shell_out('node -v', user: node['nodejs']['user']).stdout}")
#     # Chef::Log.info("The current Yarn version is #{shell_out('yarn -v', user: node['nodejs']['user']).stdout}")
#   end
# end
