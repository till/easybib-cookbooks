template "#{node['php-fpm']['prefix']}/etc/php/mysqli-settings.ini" do
  mode '0644'
  source 'mysqli.ini.erb'
  variables(
    'name' => 'mysqli',
    'directives' => {
      'reconnect' => node['php-mysqli']['reconnect']
    }
  )
end
