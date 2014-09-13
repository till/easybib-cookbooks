include_recipe "tsung::dependencies"

tsungver = node["tsung"]["version"]
pkgrev = node["tsung"]["pkgrev"]

deb_pkg_name = "tsung_#{tsungver}-#{pkgrev}_all.deb"
deb_local = "#{Chef::Config[:file_cache_path]}/#{deb_pkg_name}"

remote_file deb_local do
  source "http://tsung.erlang-projects.org/dist/ubuntu/#{deb_pkg_name}"
  mode "0644"
  backup false
  not_if do
    File.exists?(deb_local)
  end
end

package deb_pkg_name do
  provider Chef::Provider::Package::Dpkg
  source deb_local
  action :install
  not_if do
    File.exists?("/usr/bin/tsung")
  end
end

include_recipe "tsung::configure"
