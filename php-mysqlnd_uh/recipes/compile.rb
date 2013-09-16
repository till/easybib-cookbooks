include_recipe "php-fpm::source"
include_recipe "subversion"

src_dir = "/tmp/mysqlnd_uh"

subversion "Download mysqlnd_uh from svn" do
  repository  "http://svn.php.net/repository/pecl/mysqlnd_uh/trunk"
  revision    "HEAD"
  destination src_dir
  action      :sync
end

php_pecl "mysqlnd_uh" do
  action [ :compile, :setup ]
  source_dir src_dir
end
