working_dir = "/tmp/php-#{node["php-fpm"][:version]}"

execute "ext/pdo: ./configure" do

  php_prefix = node["php-fpm"][:prefix]

  php_opts = []
  php_opts << "--with-config-file-path=#{php_prefix}/etc"
  php_opts << "--with-config-file-scan-dir=#{php_prefix}/etc/php"
  php_opts << "--prefix=#{php_prefix}"

  php_ext = "--disable-all --enable-pdo=shared --with-pdo-mysql=shared --without-pdo-sqlite"

  cwd "#{working_dir}"

  command "./configure #{php_opts.join(' ')} --disable-cgi --disable-ipv6 --disable-short-tags #{php_ext}"

end

execute "ext/pdo: make" do
  cwd "#{working_dir}"
  command "make"
end

execute "ext/pdo: copy to extension_dir" do
  cwd "#{working_dir}"
  command "cp ./modules/pdo*.so /usr/local/lib/php/extensions/no-debug-non-zts-20090626/"
end
