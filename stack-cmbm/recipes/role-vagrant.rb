required_packages = [
  'libxml2', 'libmysqlclient-dev', 'nodejs', 'autoconf', 'bison', 'build-essential', 'libssl-dev', 'libyaml-dev',
  'libreadline6-dev', 'zlib1g-dev', 'libncurses5-dev', 'libffi-dev', 'libgdbm3', 'libgdbm-dev', 'libreadline-dev',
  'redis-server', 'qt5-default', 'libqt5webkit5-dev', 'gstreamer1.0-plugins-base', 'gstreamer1.0-tools'
]

required_packages.each do |p|
  package p
end

include_recipe 'ies-mysql'
include_recipe 'ies-mysql::dev'
include_recipe 'stack-cmbm::role-nginxapp'
include_recipe 'stack-cmbm::deploy-vagrant'
