include_recipe 'nginx-app::service'

cookbook_file "#{node['nginx-app']['config_dir']}/conf.d/smokeping.conf" do
  group node['nginx-app']['group']
  source 'cgi.conf'
  owner node['nginx-app']['user']
  notifies :reload, 'service[nginx]'
end

smokeping_dir = '/usr/share/smokeping/www'

link '/usr/share/nginx/html/smokeping' do
  to smokeping_dir
end

link "#{smokeping_dir}/smokeping.cgi" do
  to '/usr/lib/cgi-bin/smokeping.cgi'
end
