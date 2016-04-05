require 'chefspec'
require 'set'

shared_examples_for 'silex nginx template' do
  let(:stack) { 'Stack Name' }
  let(:fastcgi_conf) { '/etc/nginx/fastcgi_params' }
  let(:template_name) { "/etc/nginx/sites-enabled/#{app_config_shortname}.conf" }
  before do
    stub_command('rm -f /etc/nginx/sites-enabled/default').and_return(true)
  end
  describe 'nginx configuration template' do
    it 'writes virtualhost' do
      expect(chef_run).to create_template(template_name)
        .with(
          :path => template_name,
          :source => 'default-web-nginx.conf.erb'
        )

      template_resource = chef_run.template(template_name)
      expect(template_resource).to notify("execute[nginx_configtest_#{app_config_shortname}]")
        .to(:run)
        .immediately
    end

    it 'sets the correct root' do
      expect(chef_run).to render_file(template_name)
        .with_content(
          include("root /srv/www/#{app_config_shortname}/current/public/;")
        )
    end

    it 'sets the correct upstream' do
      expect(chef_run).to render_file(template_name)
        .with_content(
          include("unix:/var/run/php-fpm/#{node['php-fpm']['pools'][0]}")
        )
        .with_content(
          include("upstream #{app_config_shortname}_phpfpm {")
        )
    end

    it 'sets the correct SCRIPT_FILENAME' do
      expect(chef_run).to render_file(template_name)
        .with_content(
          include('fastcgi_param SCRIPT_FILENAME $document_root/index.php;')
        )
    end

    it 'configure access-logging' do
      expect(chef_run).to render_file(template_name)
        .with_content(
          include('access_log off;')
        )
    end

    describe 'pools' do
      before do
        node.set['php-fpm']['pools'] = %w(www1 www2 www3)
      end

      it 'creates three upstreams' do
        node['php-fpm']['pools'].each do |pool_name|
          expect(chef_run).to render_file(template_name)
            .with_content(
              include("unix:/var/run/php-fpm/#{pool_name}")
            )
        end
      end
    end
  end
end
