directory node['s3-syncer']['path'] do
  recursive true
  owner "www-data"
  group "www-data"
  mode  0755
  action :create
end

if !File.exist?("#{node['s3-syncer']['path']}/bin/syncer")
  remote_file "#{node['s3-syncer']['path']}/syncer.tar.gz" do
    source node['s3-syncer']['source']
    mode 0755
    owner "www-data"
    group "www-data"
  end

  execute "Extracting S3 Syncer" do
    user "www-data"
    cwd node['s3-syncer']['path']
    command "tar xf syncer.tar.gz --strip 1"
  end

  execute "Installing S3 Syncer" do
    user "www-data"
    cwd node['s3-syncer']['path']
    command "`which php` composer-AWS_S3.phar --no-interaction install --prefer-source --optimize-autoloader"
  end
end
