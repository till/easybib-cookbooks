include_recipe 'nginx-app::service'

vhost_dir = "#{node['nginx-app']['config_dir']}/sites-enabled"

# domains where any old url gets redirected to same uri on new domain
if node['redirector'].attribute?('domains')
  node['redirector']['domains'].each do |domain_name, new_domain_name|
    template "#{vhost_dir}/redir-#{domain_name}.conf" do
      source 'redirect.conf.erb'
      mode   '0644'
      owner  node['nginx-app']['user']
      group  node['nginx-app']['group']
      variables(
        :domain_name => domain_name,
        :new_domain_name => new_domain_name,
        :keep_uri => true
      )
      notifies :reload, 'service[nginx]', :delayed
    end
  end
end

# domains where any old url gets to / on new one
if node['redirector'].attribute?('domains_no_uri')
  node['redirector']['domains_no_uri'].each do |domain_name, new_domain_name|
    template "#{vhost_dir}/redir-#{domain_name}.conf" do
      source 'redirect.conf.erb'
      mode   '0644'
      owner  node['nginx-app']['user']
      group  node['nginx-app']['group']
      variables(
        :domain_name => domain_name,
        :new_domain_name => new_domain_name,
        :keep_uri => false
      )
      notifies :reload, 'service[nginx]', :delayed
    end
  end
end

if node['redirector'].attribute?('urls')
  node['redirector']['urls'].each do |domain_name, rewrites|
    template "#{vhost_dir}/urls-#{domain_name}.conf" do
      source 'redirect-single.conf.erb'
      mode '0644'
      owner node['nginx-app']['user']
      group node['nginx-app']['group']
      variables(
        :domain_name => domain_name,
        :rewrites => rewrites
      )
      notifies :reload, 'service[nginx]', :delayed
    end
  end
end

if node['redirector'].attribute?('ssl')
  unless File.exist?("#{node['ies-letsencrypt']['ssl_dir']}/cert.combined.pem")
    package 'openssl'

    ies_ssl_selfsigned 'example.org'

    # install self-signed cert so we can continue
    fake_deploy = {}
    fake_deploy['ssl_certificate_key'] = '/tmp/example.org.key'
    fake_deploy['ssl_certificate'] = '/tmp/example.org.crt'

    easybib_sslcertificate 'install_ssl' do
      deploy fake_deploy
      action :create
    end
  end

  ssl_domains = node.fetch('redirector', {}).fetch('ssl', {})

  template "#{vhost_dir}/ssl-letsencrypt-certbot.conf" do
    source 'redirect-certbot.conf.erb'
    mode '0644'
    owner node['nginx-app']['user']
    group node['nginx-app']['group']
    variables(
      :certbot_port => node['ies-letsencrypt']['certbot']['port'],
      :domains => ssl_domains
    )
    notifies :reload, 'service[nginx]', :delayed
  end

  template "#{vhost_dir}/ssl-letsencrypt-rewrites.conf" do
    source 'redirect-ssl.conf.erb'
    mode '0644'
    owner node['nginx-app']['user']
    group node['nginx-app']['group']
    variables(
      :ssl_dir => node['ies-letsencrypt']['ssl_dir'],
      :domains => ssl_domains
    )
    notifies :reload, 'service[nginx]', :delayed
  end

  node.set['ies-letsencrypt']['domains'] = ssl_domains.keys
  include_recipe 'ies-letsencrypt'
end
