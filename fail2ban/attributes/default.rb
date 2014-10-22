#
# Cookbook Name:: fail2ban
# Attributes:: default
#
# Copyright 2013, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# fail2ban.conf configuration options
default['fail2ban']['loglevel'] = 3
default['fail2ban']['socket'] = '/var/run/fail2ban/fail2ban.sock'
default['fail2ban']['logtarget'] = 'SYSLOG'
default['fail2ban']['pidfile'] = '/var/run/fail2ban/fail2ban.pid'

# These values will only be printed to fail2ban.conf
# if node['fail2ban']['logtarget'] is set to 'SYSLOG'
default['fail2ban']['syslog_target'] = '/var/log/fail2ban.log'
default['fail2ban']['syslog_facility'] = '1'

# jail.conf configuration options
default['fail2ban']['ignoreip'] = '127.0.0.1/8'
default['fail2ban']['findtime'] = 600
default['fail2ban']['bantime'] = 300
default['fail2ban']['maxretry'] = 5
default['fail2ban']['backend'] = 'polling'
default['fail2ban']['email'] = 'root@localhost'
default['fail2ban']['action'] = 'action_'
default['fail2ban']['banaction'] = 'iptables-multiport'
default['fail2ban']['mta'] = 'sendmail'
default['fail2ban']['protocol'] = 'tcp'
default['fail2ban']['chain'] = 'INPUT'

# custom filters.
# format: { name: { failregex: '', ignoreregex: ''} }
default['fail2ban']['filters'] = {}

case node['platform_family']
when 'rhel', 'fedora'
  default['fail2ban']['auth_log'] = '/var/log/secure'
when 'debian'
  default['fail2ban']['auth_log'] = '/var/log/auth.log'
end

default['fail2ban']['services'] = {
  'ssh' => {
    'enabled' => 'true',
    'port' => 'ssh',
    'filter' => 'sshd',
    'logpath' => node['fail2ban']['auth_log'],
    'maxretry' => '3'
  }
}

case node['platform_family']
when 'rhel', 'fedora'
  default['fail2ban']['services']['ssh-iptables'] = {
    'enabled' => false
  }
end
