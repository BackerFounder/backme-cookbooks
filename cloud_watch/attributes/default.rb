default['cloud_watch']['aws_access_key'] = ''
default['cloud_watch']['aws_access_secret'] = ''
default['cloud_watch']['aws_region'] = 'ap-northeast-1'

default['cloud_watch']['cwagent_deb_url'] = 'https://s3.amazonaws.com/amazoncloudwatch-agent/debian/amd64/latest/amazon-cloudwatch-agent.deb'

default['cloud_watch']['disk_used_percent']['alarm_actions_arn'] = ''
default['cloud_watch']['disk_used_percent']['threshold'] = 80
default['cloud_watch']['disk_used_percent']['device'] = 'nvme0n1p1'
default['cloud_watch']['disk_used_percent']['fstype'] = 'ext4'


