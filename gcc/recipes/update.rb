
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
  command 'apt-get install -y gcc g++ gcc-7 g++-7'
  notifies :run, 'execute[update-alternatives]', :immediately
  action :nothing
end

execute 'update-alternatives' do
  user 'root'
  command 'update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 70 --slave /usr/bin/g++ g++ /usr/bin/g++-7'
  action :nothing
end
