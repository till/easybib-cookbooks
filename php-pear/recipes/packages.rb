#
# Cookbook Name:: php-pear
# Recipe:: packages
#
# Copyright 2010-2012, Till Klampaeckel
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

packages = {
  "Crypt_HMAC2-beta"                          => "pear.php.net",
  "Net_Gearman-alpha"                         => "pear.php.net",
  "Services_Amazon_S3-alpha"                  => "pear.php.net",
  "Net_CheckIP2-1.0.0RC3"                     => "pear.php.net",
  "HTMLPurifier"                              => "htmlpurifier.org",
  "Easybib_Form_Decorator-0.2.0"              => "easybib.github.com/pear",
  "Lagged_Loader-alpha"                       => "easybib.github.com/pear",
  "StatsD-alpha"                              => "easybib.github.com/pear",
  "Lagged_Session_SaveHandler_Memcache-0.5.0" => "easybib.github.com/pear",
  "Rediska-0.5.6"                             => "easybib.github.com/pear"
}

# install packages
packages.each do |package,channel|

  if !package.index('-').nil? 
    attrs = package.split('-')
    package, version = attrs
  else
    version = ""
  end

  puts "PACKAGE: #{package}, Version: #{version}"

  php_pear "#{package}" do
    action  :install_if_missing
    channel "#{channel}"
    force   true
    version "#{version}"
  end
end

php_pear "DoctrineCommon" do
  action  :install_if_missing
  channel "pear.doctrine-project.org"
  version "2.1.4"
end

php_pear "DoctrineDBAL" do
  action  :install_if_missing
  channel "pear.doctrine-project.org"
  version "2.1.6"
end

php_pear "DoctrineORM" do
  action  :install_if_missing
  channel "pear.doctrine-project.org"
  version "2.1.6"
end
