#
# Cookbook Name:: php-fpm
# Recipe:: pspell
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

package "libpspell-dev"

working_dir = "/tmp/php-#{node["php-fpm"][:version]}"

execute "ext/pspell: ./configure" do

  php_prefix = node["php-fpm"][:prefix]

  php_opts = []
  php_opts << "--with-config-file-path=#{php_prefix}/etc"
  php_opts << "--with-config-file-scan-dir=#{php_prefix}/etc/php"
  php_opts << "--prefix=#{php_prefix}"

  php_ext = "--disable-all --with-pspell=shared"

  cwd "#{working_dir}"

  command "./configure #{php_opts.join(' ')} --disable-cgi --disable-ipv6 --disable-short-tags #{php_ext}"

end

execute "ext/pspell: make" do
  cwd "#{working_dir}"
  command "make"
end

execute "ext/pspell: copy to extension_dir" do
  cwd "#{working_dir}"
  command "cp ./modules/pspell.so /usr/local/lib/php/extensions/no-debug-non-zts-20090626/"
end
