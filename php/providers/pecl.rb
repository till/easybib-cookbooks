action :install do

  extension = new_resource.name
  so_file   = "/usr/local/lib/php/extensions/no-debug-non-zts-20090626/#{extension}.so"

  # TODO: new_resource.version
  execute "pecl install #{extension}" do
    not_if do
      ::File.exists?(so_file)
    end
  end
end

action :setup do

  package  = new_resource.name
  ini_file = "/usr/local/etc/php/#{new_resource.name}.ini"

  execute "enable PHP extension #{package}" do
    command "echo 'extension=#{package}.so' >> #{ini_file}"
    not_if do
      ::File.exists?(ini_file)
    end
  end
end
