require 'securerandom'

action :create do

  file = "#{new_resource.path}/config.inc.php"
  c = template file do
    cookbook 'phpmyadmin'
    source 'config.inc.php.erb'
    mode '0750'
    variables(
      :servers => new_resource.servers,
      :secret => SecureRandom.hex(8)
    )
    owner node['nginx-app']['user']
    group node['nginx-app']['group']
  end
  new_resource.updated_by_last_action(c.updated_by_last_action?)
end

action :delete do

  file = "#{new_resource.path}/config.inc.php"
  f = file file do
    action :delete
  end

  new_resource.updated_by_last_action(f.updated_by_last_action?)
end
