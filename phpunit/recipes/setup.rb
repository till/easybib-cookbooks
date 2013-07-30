packages = ["phpunit", "DbUnit"]

packages.each do |p|
  php_pear p do
    action  :install_if_missing
    channel "pear.phpunit.de"
    force   true
    version version
  end
end
