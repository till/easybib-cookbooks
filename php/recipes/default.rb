# this is a test
php_pear "Rediska" do
  action :install_if_missing
  channel "easybib.github.com/pear"
  version "0.5.6"
end

php_pear "Rediska" do
  action :uninstall
end
