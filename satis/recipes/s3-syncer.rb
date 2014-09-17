directory node['s3-syncer']['path'] do
  recursive true
  owner node['nginx-app']['user']
  group node['nginx-app']['group']
  mode  0755
  action :create
end

unless File.exist?("#{node['s3-syncer']['path']}/bin/syncer")
  remote_file "#{node['s3-syncer']['path']}/syncer.tar.gz" do
    source node['s3-syncer']['source']
    mode 0755
    owner node['nginx-app']['user']
    group node['nginx-app']['group']
  end

  execute 'Extracting S3 Syncer' do
    user node['nginx-app']['user']
    cwd node['s3-syncer']['path']
    command 'tar xf syncer.tar.gz --strip 1'
  end

  execute 'Installing S3 Syncer' do
    user node['nginx-app']['user']
    cwd node['s3-syncer']['path']
    command '`which php` composer-AWS_S3.phar --no-interaction install --prefer-source --optimize-autoloader'
  end
end
