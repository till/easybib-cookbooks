action :install do
  # TODO: new_resource.version
  execute "pecl install #{new_resource.name}"
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
