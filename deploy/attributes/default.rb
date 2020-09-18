case node['platform']
when 'ubuntu'
  default['deploy']['user'] = 'root'
  default['deploy']['group'] = 'root'
  default['deploy']['home'] = '/root'
end

default['deploy']['git_host'] = 'github.com'
