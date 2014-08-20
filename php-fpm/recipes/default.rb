#
# Cookbook Name:: php-fpm
# Recipe:: install-apt
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

include_recipe "apt::ppa"
include_recipe "apt::easybib"

include_recipe "php-fpm::prepare"

if !node["php-fpm"]["packages"].empty?
  apt_packages = node["php-fpm"]["packages"].split(',')

  apt_packages.each do |p|
    package p do
      action :install
    end
  end
end

include_recipe "php-fpm::configure"
include_recipe "php-apc::default"

expected_prefix = "/usr/local/bin"
install_prefix = "#{node["php-fpm"]["prefix"]}/bin"

phps = ["/usr/bin/php", "#{expected_prefix}/php"]

phps.each do |php_bin|
  link php_bin do
    to "#{install_prefix}/php"
    only_if do
      File.exists?("#{install_prefix}/php")
    end
  end
end

bins = ["pear", "peardev", "pecl", "phar", "phar.phar", "php-config", "phpize"]

bins.each do |php_bin|

  real_bin = "#{install_prefix}/#{php_bin}"

  link "#{expected_prefix}/#{php_bin}" do
    to real_bin
    only_if do
      File.exists?(real_bin)
    end
  end

end
