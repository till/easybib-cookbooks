node['deploy'].each do |application, deploy|

  next unless allow_deploy(application, 'packetbeat')

  include_recipe 'elasticsearch'
  include_recipe 'nginx-app::service'

  apt_package 'curl'

  cookbook_file "#{Chef::Config['file_cache_path']}/packetbeat.template.json"  do
    source 'packetbeat.template.json'
    notifies :start, 'service[elasticsearch]', :immediately
  end
  
  # the ugliest thing I ever did. elasticsearch needs some time to be available, so
  # triggering curl directly afterwards causes the process to fail.
  # there is no nice check in chef I am aware of.
  # my first workaround was to use "retry-max-time" with curl, but retries with curl
  # do not work for "connection refused".
  # so lets use sleep for now, but this is pretty much a FIXME if anyone has a better idea.
  
  execute 'this sucks: wait for elasticsearch start' do
    command 'sleep 15'
  end

  curl_command = 'curl '
  # curl_command << '--retry-delay 1 --retry-max-time 60 '
  curl_command << "-XPUT 'http://127.0.0.1:9200/_template/packetbeat' "
  curl_command << "-d@#{Chef::Config['file_cache_path']}/packetbeat.template.json "
  execute 'create packetbeat schema' do # ~FC041
    command curl_command
  end

  include_recipe 'packetbeat::dashboards'

  easybib_deploy 'packetbeat' do
    deploy_data deploy
    app application
  end

  require 'uri'
  elasticsearch = URI(node['packetbeat']['config']['elasticsearch'])

  unless elasticsearch.user.nil?
    # we use this as a template since its reused in easybib_nginx below
    # to indicate if htpasswd should be used
    htpasswd = '/etc/nginx/packetbeat.htpasswd'
    template htpasswd do
      source 'htpasswd.erb'
      mode '0644'
      variables(
        :user => elasticsearch.user,
        :password => elasticsearch.password.crypt(elasticsearch.user)
      )
    end
  end

  elasticsearch_nocredentials = elasticsearch
  elasticsearch_nocredentials.user = nil
  elasticsearch_nocredentials.password = nil

  template "#{deploy['deploy_to']}/current/#{deploy['document_root']}/config.js"  do
    source 'config.js.erb'
    mode '0644'
    variables(
      :elasticsearch => elasticsearch_nocredentials.to_s
    )
  end

  easybib_nginx 'packetbeat' do
    template_cookbook 'packetbeat'
    config_template 'packetbeat.nginx.erb'
    doc_root deploy['document_root']
    htpasswd htpasswd
    domain_name deploy['domains'].join(' ')
    notifies :restart, 'service[nginx]', :delayed
  end

end
