include_recipe 'ies::role-phpapp'
include_recipe 'supervisor'

include_recipe 'php::module-soap'
include_recipe 'php::module-tidy'
