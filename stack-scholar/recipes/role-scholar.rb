include_recipe 'ies::role-phpapp'
include_recipe 'php::module-soap'
include_recipe 'php::module-tidy'

include_recipe 'stack-scholar::deploy'
