php_version = node['stack-easybib']['php_version']

php_core_deps = %W(
  php#{php_version}-bcmath
  php#{php_version}-cli
  php#{php_version}-ctype
  php#{php_version}-curl
  php#{php_version}-dom
  php#{php_version}-fileinfo
  php#{php_version}-fpm
  php#{php_version}-iconv
  php#{php_version}-intl
  php#{php_version}-json
  php#{php_version}-mbstring
  php#{php_version}-memcache
  php#{php_version}-pdo-mysql
  php#{php_version}-simplexml
  php#{php_version}-sockets
  php#{php_version}-tokenizer
  php#{php_version}-xml
  php#{php_version}-xmlreader
  php#{php_version}-xmlwriter
  php#{php_version}-opcache
  php#{php_version}-zip
)

node.normal['php-fpm']['packages'] = php_core_deps.join(',')

link '/usr/local/bin/php' do
  to '/usr/bin/php'
end

include_recipe 'ies::role-phpapp'
include_recipe 'php::module-apc'
include_recipe 'php::module-gearman'
include_recipe 'php::module-mysqli'
include_recipe 'php::module-posix'
include_recipe 'php::module-phar'
include_recipe 'php::module-soap'
include_recipe 'php::module-tidy'
include_recipe 'php::module-soap'
include_recipe 'php::module-tidy'

include_recipe 'supervisor'
