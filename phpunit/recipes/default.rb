# this cookbook sets up PHPUnit 3.4

phpunit_location = "/usr/local/phpunit34"

pear_bin = `pear config-get bin_dir`

execute "enable auto_discover" do
  command "pear config-set auto_discover 1"
end

execute "install PHPUnit 3.4" do
  command "pear install --installroot #{phpunit_location} pear.phpunit.de/PHPUnit-3.4.15"
end

link "#{pear_bin}/phpunit34" do
  to "#{phpunit_location}#{pear_bin}/phpunit"
end
