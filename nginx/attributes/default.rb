# frozen_string_literal: true

default['nginx']['user'] = ''
default['nginx']['group'] = ''
default['nginx']['home'] = ''
default['nginx']['work_processses'] = '10'
default['nginx']['worker_connections'] = '1024'
default['nginx']['keepalive_timeout'] = 65
default['nginx']['log_dir'] = '/var/log/nginx'
default['nginx']['gzip_types'] = [
  "application/json",
  "application/javascript",
  "application/x-javascript",
  "application/xhtml+xml",
  "application/xml",
  "application/xml+rss",
  "text/css",
  "text/javascript",
  "text/plain",
  "text/xml"
]
