if !node["deploy"]["deploy_to"]
  node.normal.deploy["deploy_to"] = "/var/www/easybib"
end

Chef::Log.debug("deploy: #{node["deploy"]["deploy_to"]}")

if !node.attribute?("docroot")
  node.normal.docroot = 'www'
end

vagrant_dir = "/vagrant_data"
domain_name = nil

if node.attribute?("vagrant") && node["vagrant"].attribute?("applications") && node["vagrant"]["applications"].attribute?("www")
  domain_name = node["vagrant"]["applications"]["www"]["domain_name"]
  vagrant_dir = File.expand_path(File.dirname(node["vagrant"]["applications"]["www"]["doc_root_location"]))
  Chef::Log.debug("WWW Vagrant dir: #{vagrant_dir}")
end

directory node["deploy"]["deploy_to"] do
  mode      "0755"
  action    :create
  recursive true
end

link "#{node["deploy"]["deploy_to"]}/current" do
  to vagrant_dir
end

template "/etc/nginx/sites-enabled/easybib.com.conf" do
  source node["nginx-app"]["conf_file"]
  mode   "0755"
  owner  node["nginx-app"]["user"]
  group  node["nginx-app"]["group"]
  variables(
    :js_alias     => node["nginx-app"]["js_modules"],
    :img_alias    => node["nginx-app"]["img_modules"],
    :css_alias    => node["nginx-app"]["css_modules"],
    :deploy       => node["deploy"],
    :application  => "easybib",
    :access_log   => node["nginx-app"]["access_log"],
    :listen_opts  => 'default_server',
    :nginx_extra  => 'sendfile  off;',
    :domain_name  => domain_name,
    :php_upstream => "unix:/var/run/php-fpm/#{node["php-fpm"]["user"]}"
  )
  notifies :restart, "service[nginx]", :delayed
end
