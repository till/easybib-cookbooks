#
# Cookbook Name:: php-fpm-src
# Recipe:: apc
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

directory "#{node["php-fpm"][:prefix]}/etc/php/" do
  action :create
  recursive true
  mode "0755"
end

remote_file "/tmp/APC-#{node["php-fpm"][:apc_version]}.tgz" do
  source "http://pecl.php.net/get/APC-#{node["php-fpm"][:apc_version]}.tgz"
  checksum "53d8442e8b7e3804537d14e5776962cfdc5ae4d8"
end

execute "APC: unpack" do
  command "cd /tmp && tar -xzf APC-#{node["php-fpm"][:apc_version]}.tgz"
end

execute "APC: phpize" do
  cwd "/tmp/APC-#{node["php-fpm"][:apc_version]}"
  command "phpize"
end

execute "APC: ./configure" do
  cwd "/tmp/APC-#{node["php-fpm"][:apc_version]}"
  command "./configure"
end

execute "APC: make, make install" do
  cwd "/tmp/APC-#{node["php-fpm"][:apc_version]}"
  command "make && make install"
end

include_recipe "php-apc::configure"
