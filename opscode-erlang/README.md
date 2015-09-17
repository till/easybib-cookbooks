opscode-erlang Cookbook
=======================
Opscode extensions for erlang applications. Includes LWRPs for setting up
an OTP service.

## License

All files in the repository are licensed under the Apache 2.0 license. If any
file is missing the License header it should assume the following is attached;

```
Copyright 2014 Chef Software Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```


Requirements
------------

#### packages
- `erlang_binary` - Like the name says.
- `runit` - To setup a service.
- `deployment-notifications` - For Hipchat notifications upon deployments.
- opscode_extensions` - For s3 artifacts download.
- `logrotate`
- `git`


Attributes
----------
None


Usage
-----
You should normally just use the otp_service LWRP, e.g. (from the opscode-bifrost cookbook):
```
# The otp_service resource handles all the generic
# OTP service logic:
# - build from source or download from S3 (depending on dev mode)
# - deploy build artifact (and send hipchat notification)
# - configure OTP service
#
sys_config = {
  :ip                   => node[app_name]['host'],
  :port                 => node[app_name]['port'],
  :superuser_id         => node[app_name]['superuser_id'],
  :db_host              => node[app_name]['database']['host'],
  :db_port              => node[app_name]['database']['port'],
  :db_name              => node[app_name]['database']['name'],
  :db_user              => node[app_name]['database']['users']['owner']['name'],
  :db_pass              => node[app_name]['database']['users']['owner']['password'],
  :pool_size            => node[app_name]['database']['connection_pool_size'],
  :max_pool_size        => node[app_name]['database']['max_connection_pool_size'],
  :log_dir              => node[app_name]['log_dir'],
  :udp_socket_pool_size => node[app_name]['stats_hero_udp_socket_pool_size'],
  :estatsd_host         => node[app_name]['estatsd_host'],
  :estatsd_port         => node['stats_hero']['estatsd_port']
}

opscode_erlang_otp_service app_name do
  action :deploy
  app_environment node['app_environment']
  revision node[app_name]['revision']
  source node[app_name]['source']
  development_mode node[app_name]['development_mode']
  aws_bucket node[app_name]['aws_bucket']
  aws_access_key_id node[app_name]['aws_access_key_id']
  aws_secret_access_key node[app_name]['aws_secret_access_key']
  root_dir node[app_name]['srv_root']
  estatsd_host node[app_name]['estatsd_host']
  hipchat_key node[app_name]['hipchat_key']
  log_dir node[app_name]['log_dir']
  console_log_count node[app_name]['console_log_count']
  console_log_mb node[app_name]['console_log_mb']
  error_log_count node[app_name]['error_log_count']
  error_log_mb node[app_name]['error_log_mb']
  owner node[app_name]['owner']
  group node[app_name]['group']
  sys_config sys_config
end
```

`otp_service` in turns relies on the following LWRPs:
- `otp_release_artifact` - Get or build the application bits. Relies on lower-level LWRPs:
-- `otp_build` - Build the application bits.
-- `s3_artifact` - Get the application bits from S3.
- `service_pkg` - Extract the application bits into a standard directory structure.
- `otp_service_config` - Configure the OTP service.

See the [Bifrost cookbook](https://github.com/opscode-cookbooks/opscode-bifrost/) for an example.


Authors
-------------------
Authors: Jean-Philippe Langlois (<jpl@opscode.com>)
