include_recipe 'stack-easybib::role-phpapp'
include_recipe 'supervisor'

include_recipe 'easybib-deploy::ssl-certificates'
include_recipe 'stack-academy::deploy'
