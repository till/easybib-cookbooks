if node["lsb"]["codename"] == 'lucid'
  include_recipe "php-intl::pecl"
else
  include_recipe "php-fpm::service"

  include_recipe "apt::ppa"
  include_recipe "apt::easybib"

  p = "php5-easybib-intl"

  package p do
    notifies :reload, "service[php-fpm]", :delayed
  end
end
