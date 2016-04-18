pkg_deps = [
  'libxml2', 'libmysqlclient-dev', 'autoconf', 'bison', 'build-essential', 'libssl-dev', 'libyaml-dev',
  'libreadline6-dev', 'zlib1g-dev', 'libncurses5-dev', 'libffi-dev', 'libgdbm3', 'libgdbm-dev', 'libreadline-dev',
  'qt5-default', 'libqt5webkit5-dev', 'gstreamer1.0-plugins-base', 'gstreamer1.0-tools'
]

pkg_deps.each do |p|
  package p
end

include_recipe 'ies::role-generic'
include_recipe 'nodejs'
include_recipe 'redis'
include_recipe 'stack-cmbm::deploy-ruby'
include_recipe 'stack-cmbm::deploy-puma'
include_recipe 'stack-cmbm::deploy-nginxapp'
