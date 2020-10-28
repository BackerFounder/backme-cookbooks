# frozen_string_literal: true

default['deploy']['user'] = ''
default['deploy']['group'] = ''
default['deploy']['home'] = ''
default['deploy']['keep_releases'] = 5
default['deploy']['git_host'] = 'github.com'
default['deploy']['custom_json_provided'] = true
# DB host, username, password, port are fetched from the data bag `aws_opsworks_rds_db_instance`
default['deploy']['db_adapter'] = 'postgresql'
default['deploy']['db_encoding'] = 'unicode'
default['deploy']['db_pool'] = 5
default['deploy']['db_name'] = ''
default['deploy']['db_port'] = '5432'
