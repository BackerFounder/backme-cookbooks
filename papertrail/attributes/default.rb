# frozen_string_literal: true

default['papertrail']['files'] = []
default['papertrail']['exclude_files'] = []
default['papertrail']['hostname'] = nil
default['papertrail']['exclude_patterns'] = []
default['papertrail']['destination_host'] = ''
default['papertrail']['destination_port'] = nil
default['papertrail']['destination_protocol'] = 'tls'
default['papertrail']['new_file_check_interval'] = nil
default['papertrail']['facility'] = nil
default['papertrail']['severity'] = nil
default['papertrail']['version'] = '0.20'
