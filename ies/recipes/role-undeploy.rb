unless is_aws && node.fetch('nginx-app', {})['user'].nil?
  crontab_user = node.fetch('nginx-app', {})['user']
  node['deploy'].each do |application, deploy|
    easybib_crontab application do
      crontab_user crontab_user
      app application
      action :delete
    end
  end
end
