case node['platform_family']
when 'debian', 'ubuntu'
  default['yarn']['package']['key'] = 'https://dl.yarnpkg.com/debian/pubkey.gpg'
  default['yarn']['package']['uri'] = 'https://dl.yarnpkg.com/debian/'
  default['yarn']['package']['distribution'] = 'stable'
end
