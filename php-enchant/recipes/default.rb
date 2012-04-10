package "autoconf"
package "libglib2.0-dev"
package "libenchant-dev"

php_pecl "enchant"

php_pecl "enchant" do
  action :setup
end
