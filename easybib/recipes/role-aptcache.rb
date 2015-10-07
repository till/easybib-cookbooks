include_recipe 'ies::setup'
include_recipe 'loggly::setup'

if get_instance_roles.include?('aptcache')
  include_recipe 'apt::cacher-ng'
end
