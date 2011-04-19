#
# Cookbook Name:: munin
# Recipe:: source
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

perlModules = ["Module::Build", "Time::HiRes", "Storable", "Digest::MD5", "HTML::Template",
  "Text::Balanced", "Params::Validate", "TimeDate", "Net::SSLeay", "Getopt::Long",
  "Log::Log4perl"]

# deps for Log::Log4perl
# IPC::Shareable
# Log::Dispatch
# Log::Dispatch::FileRotate
# MIME::Lite
# Mail::Sender
# Mail::Sendmail

perlModules.each do |perlModule|
  execute "install #{perlModule} from CPAN" do
    command "perl -MCPAN -e 'install #{perlModule}'"
  end
end

user node[:munin][:user] do
  comment "munin"
  system  true
  shell   "/bin/false"
end

directory node[:munin][:log_dir] do
  owner     node[:munin][:user]
  group     node[:munin][:group]
  recursive true
end

muninVer     = node[:munin][:version]
tmpDir       = "/tmp/munin-#{muninVer}"
downloadLink = "http://downloads.sourceforge.net/project/munin/munin%20stable/#{muninVer}/munin-#{muninVer}.tar.gz?r=http%3A%2F%2Fyour.mother"

remote_file "/tmp/munin-#{muninVer}.tar.gz" do
  source "#{downloadLink}"
  not_if do File.exists?("#{tmpDir}") end
end

execute "extract" do
  command "tar -zxf /tmp/munin-#{muninVer}.tar.gz"
  not_if  do File.exists?("#{tmpDir}") end
end

template "#{tmpDir}/Makefile.config" do
  source "Makefile.config.erb"
end

installCmds = ["make", "make install"]
installCmds.each do |cmd|
  execute "#{cmd}" do
    cwd         "#{tmpDir}"
    environment ({'PREFIX' => node[:munin][:prefix]})
  end
end

include_recipe "munin::template"
include_recipe "munin::logrotate"
