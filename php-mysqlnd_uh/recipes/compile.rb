php_ext_dir = `/usr/local/bin/php -r "echo ini_get('extension_dir');"`.strip
src_dir     = "/tmp/mysqlnd_uh"

subversion "Download mysqlnd_uh from svn" do
  repository  "http://svn.php.net/repository/pecl/mysqlnd_uh/trunk"
  revision    "HEAD"
  destination src_dir
  action      :sync
end

execute "compile ext/mysqlnd_uh" do
  cwd       src_dir
  command   "phpize && ./configure && make"
  not_if do File.exists?("#{php_ext_dir}/mysqlnd_uh.so") end
end

execute "copy ext/mysqlnd_uh to ext_dir" do
  command   "cp modules/mysqlnd_uh.so #{php_ext_dir}/mysqlnd_uh.so"
  cwd       src_dir
  not_if do File.exists("#{php_ext_dir}/mysqlnd_uh.so") end
end
