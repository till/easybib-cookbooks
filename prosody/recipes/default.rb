case node["platform"]
when "debian", "ubuntu"
  include_recipe "prosody::apt"
  package "lua-event"
  package "liblua5.1-sec1"
  package_name = "prosody"
when "freebsd", "gentoo"
  package_name = "net-im/prosody"
when "netbsd"
  package_name = "chat/prosody"
when "openbsd"
  package_name = "net/prosody"
default
  Chef::Log.error("Unsupported: #{node["platform"]}")
end

package "installing prosody" do
  package_name package_name
  action :install
end

include_recipe "prosody::configure"
include_recipe "prosody::groups"
