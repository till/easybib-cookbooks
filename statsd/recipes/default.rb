# temporary until we have time to import the packagecloud cookbook
repo_user = node['statsd']['repo']['package_cloud_user']
repo_name = node['statsd']['repo']['package_cloud_repo']
repo_file = "/etc/apt/sources.list.d/#{repo_user}_#{repo_name}.list"

remote_file "#{Chef::Config[:file_cache_path]}/install-package_cloud.sh" do
  source "https://packagecloud.io/install/repositories/#{repo_user}/#{repo_name}/script.deb.sh"
  mode 0755
  not_if { ::File.exist?(repo_file) }
end

execute 'run-package_cloud.sh' do
  command "#{Chef::Config[:file_cache_path]}/install-package_cloud.sh"
  not_if { ::File.exist?(repo_file) }
end

package 'statsd' do
  action :install
  version node['statsd']['version']
end

include_recipe 'statsd::configure'
