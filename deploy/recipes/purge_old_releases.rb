app = search(:aws_opsworks_app).first
app_path = "/srv/www/#{app['shortname']}"

raise "Number of keep releases must larger than 0" if node['deploy']['keep_releases'] < 1

ruby_block 'get list of release' do
  block do
    release_list = shell_out("ls #{app_path}/releases", user: node['deploy']['user']).stdout.split
    node.default['deploy']['release_list'] = release_list
    Chef::Log.info("releases: #{release_list.inspect}")
  end
end

release_list = shell_out("ls #{app_path}/releases", user: node['deploy']['user']).stdout.split
Chef::Log.info("release_list.length : #{release_list.length}")
(0..(release_list.length - node['deploy']['keep_releases'] - 1)).each do |index|
  directory File.join(app_path, 'releases', release_list[index]) do
    owner node['deploy']['user']
    group node['deploy']['group']
    recursive true
    action :delete
  end
end

ruby_block 'get list of release' do
  block do
    release_list = shell_out("ls #{app_path}/releases", user: node['deploy']['user']).stdout.split
    node.default['deploy']['release_list'] = release_list
    Chef::Log.info("after purged: #{release_list.inspect}")
  end
end
