find_package = Mixlib::ShellOut.new("dpkg -s php5-easybib-apcu")
find_package.run_command

if find_package.exitstatus == 0
  package "php5-easybib-apcu"
else
  package "php5-easybib-apc"
end

include_recipe "php-apc::configure"
