include_recipe "apt::ppa"
include_recipe "apt::easybib"

["php5-easybib-apcu", "php5-easybib-apc"].each do |package_name|
  Chef::Log.debug("Trying #{package_name}")
  package package_name do
    action :install
    only_if do
      find_package = Mixlib::ShellOut.new("apt-cache showpkg #{package_name}")
      find_package.run_command
      find_package.exitstatus == 0 && !find_package.stdout.empty?
    end
  end
end

include_recipe "php-apc::configure"
