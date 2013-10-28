case node["platform"]
when "debian", "ubuntu"
  include_recipe "prosody::apt"

  ["lua-event", "liblua5.1-sec1", "lua-zlib"].each do |package_dep|
    package "installing #{package_dep} for prosody" do
      package_name package_dep
      action :install
    end
  end

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
