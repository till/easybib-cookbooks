# Installs our base ubuntu packages, and
# removes unneeded/buggy ones that are preinstalled by opsworks

base_packages = [
  'htop', 'jwhois', 'multitail',
  'apache2-utils', 'strace', 'rsync',
  'manpages', 'manpages-dev',
  'git-core', 'unzip', 'realpath', 'curl'
]

base_packages.each do |p|
  package p
end

# landscape is buggy
# https://bugs.launchpad.net/ubuntu/+source/pam/+bug/805423
package 'landscape-client' do
  action :purge
end

# opsworks installs this but we don't need it
['ganglia-monitor', 'libganglia1'].each do |p|
  package p do
    action :purge
  end
end
