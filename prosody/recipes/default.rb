case node["platform"]
when "debian", "ubuntu"
  include_recipe "prosody::apt"

  ["lua-event", "luasec-prosody", "lua-zlib"].each do |package_dep|
    package "installing #{package_dep} for prosody" do
      package_name package_dep
      action :install
    end
  end

  package_name = "prosody"
default
  Chef::Log.error("Unsupported: #{node["platform"]}")
end

package "installing prosody" do
  package_name package_name
  action :install
end

#if it already is installed, do upgrade:
package "updating prosody" do
  package_name package_name
  action :upgrade
end

include_recipe "prosody::configure"
include_recipe "prosody::groups"
