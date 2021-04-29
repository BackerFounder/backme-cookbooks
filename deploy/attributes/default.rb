### Git repository settings
default['deploy']['git_host'] = 'github.com'

### DB settings
# DB host, username, password, port are fetched from the data bag `aws_opsworks_rds_db_instance`
default['deploy']['db_adapter'] = 'postgresql'
default['deploy']['db_encoding'] = 'unicode'
default['deploy']['db_pool'] = 5
default['deploy']['db_name'] = ''
default['deploy']['db_port'] = '5432'

### Migration settings
default['deploy']['migrate_rake'] = 'db:migrate'

### Application settings
default['deploy']['rails_env'] = 'production'
default['deploy']['application_yml'] = {}
default['deploy']['public_output_path'] = ''
default['deploy']['s3_asset_path'] = ''

### Logrtate settings
default['deploy']['logrotate_frequency'] = 'daily'
default['deploy']['logrotate_options'] = %w(missingok compress delaycompress notifempty copytruncate)
default['deploy']['logrotate_days'] = 30
