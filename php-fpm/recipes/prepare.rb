#
# Cookbook Name:: php-fpm
# Recipe:: prepare
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

directory node["php-fpm"]["tmpdir"] do
  mode "0755"
  owner node["php-fpm"]["user"]
  group node["php-fpm"]["group"]
end

directory File.dirname(node["php-fpm"]["logfile"]) do
  mode "0755"
  owner node["php-fpm"]["user"]
  group node["php-fpm"]["group"]
end

file node["php-fpm"]["logfile"] do
  mode "0755"
  owner node["php-fpm"]["user"]
  group node["php-fpm"]["group"]
end

file node["php-fpm"]["slowlog"] do
  mode "0755"
  owner node["php-fpm"]["user"]
  group node["php-fpm"]["group"]
end

file node["php-fpm"]["fpmlog"] do
  mode "0755"
  owner node["php-fpm"]["user"]
  group node["php-fpm"]["group"]
end

directory node["php-fpm"]["socketdir"] do
  mode "0755"
  owner node["php-fpm"]["user"]
  group node["php-fpm"]["group"]
end

template "/etc/init.d/php-fpm" do
  mode   "0755"
  source "init.d.php-fpm.erb"
  owner  node["php-fpm"]["user"]
  group  node["php-fpm"]["group"]
end
