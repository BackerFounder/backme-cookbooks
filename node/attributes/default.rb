# frozen_string_literal: true

default['nodejs']['version'] = '12.16.3'
default['nodejs']['nvm_version'] = 'v0.36.0'
default['nodejs']['nvm_dir'] = '/.nvm'
default['nodejs']['user'] = ''
default['nodejs']['group'] = ''
default['nodejs']['home'] = ''

case node['platform_family']
when 'debian'
  default['yarn']['package']['key'] = 'https://dl.yarnpkg.com/debian/pubkey.gpg'
  default['yarn']['package']['uri'] = 'https://dl.yarnpkg.com/debian/'
  default['yarn']['package']['distribution'] = 'stable'
end
