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

stdInstall = [ "source", "easybib" ]

Chef::Log.debug("Source used: #{node["php-fpm"][:source]}")

if stdInstall.include?(node["php-fpm"][:source])
  etc_cli_dir = "#{node["php-fpm"][:prefix]}/etc"
  etc_fpm_dir = "#{node["php-fpm"][:prefix]}/etc"
  conf_cli = "php-cli.ini"
  conf_fpm = "php.ini"
else
  if node["php-fpm"][:source] == "ubuntu"
    etc_cli_dir = "/etc/php5/cli"
    etc_fpm_dir = "/etc/php5/fpm"
    conf_cli = "php.ini"
    conf_fpm = "php.ini"
  else
    Chef::Log.error("Unknown source: #{node["php-fpm"][:source]}. Bailed.")
    return
  end
end

template "#{etc_fpm_dir}/#{conf_fpm}" do
  mode "0755"
  source "php.ini.erb"
  variables(
    :enable_dl => "Off"
  )
  owner node["php-fpm"][:user]
  group node["php-fpm"][:group]
end

template "#{etc_cli_dir}/#{conf_cli}" do
  mode "0755"
  source "php.ini.erb"
  variables(
    :enable_dl => "On"
  )
  owner node["php-fpm"][:user]
  group node["php-fpm"][:group]
end

template "#{etc_fpm_dir}/php-fpm.conf" do
  mode "0755"
  source "php-fpm.conf.erb"
  owner node["php-fpm"][:user]
  group node["php-fpm"][:group]
end

if node["php-fpm"][:source] == "source"
  directory "#{node["php-fpm"][:prefix]}/etc/php" do
    owner "root"
    group "root"
    mode "0755"
    action :create
  end
end

template "/etc/default/php-fpm" do
  source "default.erb"
  mode "0644"
end

template "/etc/init.d/php-fpm" do
  mode "0755"
  source "init.d.php-fpm.erb"
  owner node["php-fpm"][:user]
  group node["php-fpm"][:group]
end

include_recipe "php-fpm::service"

template "/etc/logrotate.d/php" do
  source "logrotate.erb"
  mode "0644"
  owner "root"
  group "root"
end
