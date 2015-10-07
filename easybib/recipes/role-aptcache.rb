include_recipe 'ies::setup'

if get_instance_roles.include?('aptcache')
  include_recipe 'apt::cacher-ng'
end
