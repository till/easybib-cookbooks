include_recipe 'apt::ppa'
include_recipe 'apt::easybib'
package 'php5-easybib-apcu' do
  action :install
end

include_recipe 'php-apc::configure'
