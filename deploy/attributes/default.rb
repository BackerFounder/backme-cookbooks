case node['platform']
when 'ubuntu'
  default['deploy']['user'] = 'deploy'
  default['deploy']['group'] = 'deploy'
end

default['deploy']['git_host'] = 'github.com'
