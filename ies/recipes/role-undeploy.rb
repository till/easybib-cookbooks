include_recipe 'easybib::crontab'

unless is_aws
  node['deploy'].each do |application, deploy|
    easybib_crontab application do
      app application
      action :delete
    end
  end
end
