include_recipe "apt::ppa"
include_recipe "apt::easybib"

case node[:lsb][:codename]
when 'lucid'
  package "php5-easybib-pspell"
when 'precise'
  package "php5-pspell"
end
