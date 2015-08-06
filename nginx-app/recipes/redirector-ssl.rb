include_recipe 'nginx-app::service'

# To deploy the ssl redirector, we need an "redirector" app with configured ssl certificate, and
# an entry in node['redirector']['domains'] where the old domain matches the first configured domain
# in the opsworks app.

vhost_dir = "#{node['nginx-app']['config_dir']}/sites-enabled"

unless node['deploy']['redirector'].nil?
  if node['deploy']['redirector']['ssl_certificate'] &&
     node['deploy']['redirector']['ssl_certificate_key']

    Chef::Log.info('Got SSL certificate data for redirector, listening on 443 as well')

    easybib_sslcertificate 'ssl-redirector' do
      deploy node['deploy']['redirector']
    end

    ssl_domain = node['deploy']['redirector']['domains'].first

    if node['redirector']['domains'].attribute?(ssl_domain)
      template "#{vhost_dir}/redir-#{ssl_domain}-ssl.conf" do
        source 'redirect-ssl.conf.erb'
        mode   '0644'
        owner  node['nginx-app']['user']
        group  node['nginx-app']['group']
        variables(
          :domain_name => ssl_domain,
          :new_domain_name => node['redirector']['domains'][ssl_domain],
          :ssl_dir => node['ssl-deploy']['directory']
        )
        notifies :restart, 'service[nginx]', :delayed
      end
    else
      Chef::Log.fatal("Unable to find the redirect target for the ssl-domain #{ssl_domain}, make sure to configure node['redirector']['domains']")
    end

  end
end
