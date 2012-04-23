#
# Cookbook Name:: php-pear
# Recipe:: channels
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

execute "PEAR: enable auto discover for channels" do
  command "pear config-set auto_discover 1"
end

channels = {
  "pear.php.net"              => "pear",
  "htmlpurifier.org"          => "hp",
  "easybib.github.com/pear"   => "easybib",
  "pear.doctrine-project.org" => "doctrine"
}

# discover PEAR channels
channels.each do |channel,shorthand|
  execute "PEAR: discover #{channel} (#{shorthand})" do
    command "pear channel-discover #{channel}"
    not_if  "pear list-channels|grep #{channel}"
  end
  execute "PEAR: update channel #{channel}" do
    command "pear channel-update #{channel}"
  end
end

execute "PEAR: upgrade all currently installed packages" do
  command "pear upgrade-all"
end
