node['deploy'].each do |application, deploy|

  next unless allow_deploy(application, 'sinopia', 'npm-proxy')

  sinopia_listener = if node.fetch('sinopia', {})['listen'].nil?
                       '127.0.0.1:4873'
                     else
                       node['sinopia']['listen']
                     end

  template '/etc/nginx/sites-enabled/sinopia-forward.conf' do
    source 'nginx-sinopia.conf.erb'
    mode   '0644'
    variables(
      'sinopia' => sinopia_listener,
      'domains' => deploy['domains']
    )
    notifies :reload, 'service[nginx]', :delayed
  end
end
