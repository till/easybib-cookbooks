include_recipe "easybib::setup"
include_recipe "loggly::setup"
if node[:lsb][:codename] == 'lucid'
  include_recipe "gearmand"
else
  include_recipe "gearmand::source"
end
