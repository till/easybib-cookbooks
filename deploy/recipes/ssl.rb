package 'nginx'
include_recipe 'nginx-lb::default'
include_recipe 'nginx-lb::service'
