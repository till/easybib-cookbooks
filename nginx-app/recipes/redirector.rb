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

  template "#{node['nginx-app']['config_dir']}/conf.d/map.conf" do
    source 'generic-conf.erb'
    mode   '0644'
    owner  node['nginx-app']['user']
    group  node['nginx-app']['group']
    variables(
      :prefix => 'map',
      :config => node['nginx-app']['map']
    )
    notifies :reload, 'service[nginx]', :delayed
  end

  node['redirector']['urls'].each do |domain_name, locations|
    template "#{vhost_dir}/urls-#{domain_name}.conf" do
      source 'redirect.conf.erb'
      mode '0644'
      owner node['nginx-app']['user']
      group node['nginx-app']['group']
      variables(
        :domain_name => domain_name,
        :locations => locations
      )
      notifies :reload, 'service[nginx]', :delayed
    end
  end
end
