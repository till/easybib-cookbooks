include_recipe "php-fpm::service"

case node[:lsb][:codename]
when 'lucid'
  include_recipe "apt::ppa"
  include_recipe "apt::easybib"

  package "php5-easybib-gearman" do
    notifies :reload, resources(:service => "php-fpm"), :delayed
  end
when 'precise'
  Chef::Log.info("Skipping this for now.")
end
