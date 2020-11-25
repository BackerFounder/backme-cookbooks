
execute 'Add ubuntu toolchain to apt repo' do
  user 'root'
  command 'add-apt-repository -y ppa:ubuntu-toolchain-r/test'
  notifies :run, 'execute[apt-get update]', :immediately
end

execute 'apt-get update' do
  command 'apt-get update'
  notifies :run, 'execute[install gcc]', :immediately
  action :nothing
end

execute 'install gcc' do
  user 'root'
  command 'apt-get install -y gcc g++ gcc-9 g++-9'
  notifies :run, 'execute[update-alternatives]', :immediately
  action :nothing
end

execute 'update-alternatives' do
  user 'root'
  command 'update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9'
  action :nothing
end
