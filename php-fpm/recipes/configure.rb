#
# Cookbook Name:: php-fpm
# Recipe:: configure
#
# Copyright 2010-2011, Till Klampaeckel
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this list
#   of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright notice, this
#   list of conditions and the following disclaimer in the documentation and/or other
#   materials provided with the distribution.
# * The names of its contributors may not be used to endorse or promote products
#   derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

include_recipe 'php-fpm::service'

config = node['php-fpm']

etc_cli_dir = "#{config['prefix']}/etc"
etc_fpm_dir = "#{config['prefix']}/etc"
conf_cli    = 'php-cli.ini'
conf_fpm    = 'php.ini'

display_errors = if config['user'] == 'vagrant'
                   'On'
                 else
                   'Off'
                 end

if config['mailsender'].nil?
  Chef::Log.info('Not adding any sendmail params')
  sendmail_params = nil
else
  sendmail_params = "-f '#{config['mailsender']}'"
  Chef::Log.info("Adding to php sendmail stmt: #{sendmail_params}")
end

template "#{etc_fpm_dir}/#{conf_fpm}" do
  mode     '0755'
  source   'php.ini.erb'
  variables(
    :enable_dl => 'Off',
    :memory_limit => config['memorylimit'],
    :display_errors => display_errors,
    :max_execution_time => config['maxexecutiontime'],
    :max_input_vars => config['ini']['max-input-vars'],
    :error_log => 'syslog',
    :tmpdir => config['tmpdir'],
    :prefix => config['prefix'],
    :sendmail_params => sendmail_params
  )
  owner    config['user']
  group    config['group']
  notifies :reload, 'service[php-fpm]', :delayed
end

template "#{etc_cli_dir}/#{conf_cli}" do
  mode '0755'
  source 'php.ini.erb'
  variables(
    :enable_dl      => 'On',
    :error_log      => 'syslog',
    :memory_limit   => '1024M',
    :display_errors => 'On',
    :max_execution_time => '-1',
    :max_input_vars => config['ini']['max-input-vars'],
    :tmpdir => config['tmpdir'],
    :prefix => config['prefix'],
    :sendmail_params => sendmail_params
  )
  owner config['user']
  group config['group']
end

pool_dir = "#{config['prefix']}/etc/php-fpm/pool.d"

template "#{etc_fpm_dir}/php-fpm.conf" do
  mode     '0755'
  source   'php-fpm.conf.erb'
  owner    config['user']
  group    config['group']
  variables(
    :pool_dir => pool_dir
  )
  notifies :reload, 'service[php-fpm]', :delayed
end

directory pool_dir do
  owner config['user']
  group config['group']
  action :create
  recursive true
end

# default pool setup by PHP package
file "#{pool_dir}/www.conf" do
  action :delete
  only_if do
    File.exist?("#{pool_dir}/www.conf") && !config['pools'].include?('www')
  end
end

config['pools'].each do |pool_name|
  template "#{pool_dir}/#{pool_name}.conf" do
    mode '0644'
    source 'pool.conf.erb'
    owner config['user']
    group config['group']
    variables(
      :pool_name => pool_name,
      :user => config['user'],
      :group => config['group'],
      :type => config['type'],
      :max_children => config['max_children'],
      :socket_dir => config['socketdir'],
      :slowlog_timeout => config['slowlog_timeout'],
      :slowlog => config['slowlog']
    )
    notifies :reload, 'service[php-fpm]', :delayed
  end
end

template '/etc/logrotate.d/php' do
  source 'logrotate.erb'
  variables(
    :logfile => config['logfile']
  )
  mode '0644'
  owner 'root'
  group 'root'
  notifies :enable, 'service[php-fpm]', :immediately
  notifies :start, 'service[php-fpm]', :immediately
end

include_recipe 'php-fpm::monit' if is_aws
