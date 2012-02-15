cookbook_file "/usr/local/etc/php/phar.ini" do
  source "phar.ini"
  mode   "0644"
end
