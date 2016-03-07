action :create do

  nginx_config_cookbook = new_resource.cookbook
  nginx_config_template = new_resource.template

  nginx_user = new_resource.nginx_user || node['nginx-app']['user']
  nginx_group = new_resource.nginx_group || node['nginx-app']['group']

  error_log = new_resource.error_log || node['nginx-app']['error_log']

  enable_fastcgi = new_resource.enable_fastcgi

  # this is a hack to maximize - currently only
  # in use in nginx-lb
  processes = if node['cpu']['total'] > 1
                (node['cpu']['total']) - 1
              else
                1
              end

  last_updated = false

  tfp = template '/etc/nginx/fastcgi_params' do
    cookbook 'nginx-app'
    source 'fastcgi_params.erb'
    mode '0755'
    owner nginx_user
    group nginx_group
    only_if { enable_fastcgi }
  end

  last_updated = true if tfp.updated_by_last_action?

  tn = template '/etc/nginx/nginx.conf' do
    source nginx_config_template
    cookbook nginx_config_cookbook
    mode '0644'
    owner nginx_user
    group nginx_group
    variables(
      :nginx_user => nginx_user,
      :processes => processes,
      :error_log => error_log
    )
  end

  last_updated = true if tn.updated_by_last_action?

  e = execute 'delete default vhost' do
    ignore_failure true
    command 'rm -f /etc/nginx/sites-enabled/default'
    only_if { new_resource.delete_default }
  end

  last_updated = true if e.updated_by_last_action?

  new_resource.updated_by_last_action(true) if last_updated
end

action :delete do
  f = file '/etc/nginx/nginx.conf' do
    action :delete
    only_if do
      File.exist?('/etc/nginx/nginx.conf')
    end
  end

  new_resource.updated_by_last_action(true) if f.updated_by_last_action?
end
