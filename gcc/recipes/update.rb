
execute 'Add ubuntu toolchain to apt repo' do
  user 'root'
  command 'add-apt-repository -y ppa:ubuntu-toolchain-r/test'
end

execute 'apt-get update' do
  command 'apt-get update'
end

execute 'install gcc' do
  user 'root'
  command 'apt-get install gcc g++ gcc-7 g++-7'
end

execute 'update-alternatives' do
  user 'root'
  command 'update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 70 --slave /usr/bin/g++ g++ /usr/bin/g++-7'
end
