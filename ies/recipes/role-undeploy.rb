unless is_aws && get_instance_roles(node).include?('nginxphpapp')
  crontab_user = node.fetch('nginx-app', {})['user'] || 'nobody'
  node['deploy'].each do |application, deploy|
    easybib_crontab application do
      crontab_user crontab_user
      app application
      action :delete
    end
  end
end
