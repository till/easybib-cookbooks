include_recipe "apt::ppa"
include_recipe "apt::easybib"

if node[:lsb][:codename] == 'lucid'
  package "php5-easybib-posix"
end
