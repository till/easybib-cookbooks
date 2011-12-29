php_ext_dir = `php -r 'ini_get("extension_dir");'`.strip
suhosin_ext = "#{php_ext_dir}/suhosin.so"
suhosin_dl  = "suhosin-#{node[:suhosin][:version]}.tar.gz"

Chef::Log.debug("PHP EXT DIR: #{php_ext_dir}, SUHOSIN: #{suhosin_ext}")

remote_file "/tmp/#{suhosin_dl}" do
  source "http://download.suhosin.org/#{suhosin_dl}"
  mode   "0644"
  not_if do
    File.exists?(suhosin_ext)
  end
end

execute "extract" do
  command "cd /tmp && tar zxf #{suhosin_dl}"
  not_if do
    File.exists?(suhosin_ext)
  end
end

execute "phpize, configure, make install" do
  command "cd /tmp/suhosin-#{node[:suhosin][:version]} && phpize && ./configure && make install"
  not_if do
    File.exists?(suhosin_ext)
  end
end

template "/usr/local/etc/php/suhosin.ini" do
  source "suhosin.ini.erb"
  mode   "0644"
end

