require 'chefspec'

describe 'nginx-app::configure' do

  let(:runner) do
    ChefSpec::Runner.new(
      :step_into => ['nginx_app_config'],
      :version => 12.04
    )
  end
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  let(:vhost) { '/etc/nginx/sites-enabled/easybib.com.conf' }
  let(:access_log) { '/some/drive/access.log' }
  let(:php_user) { 'some_user_account' }
  let(:stack) { 'Stack Name' }
  let(:template_name) { 'render vhost: easybib' }
  let(:fastcgi_conf) { '/etc/nginx/fastcgi_params' }

  describe 'deployment' do
    before do
      stub_command('rm -f /etc/nginx/sites-enabled/default').and_return(true)

      node.set['deploy'] = {}

      node.set['easybib']['cluster_name'] = stack

      node.set['opsworks']['instance']['layers'] = ['nginxphpapp']
      node.set['opsworks']['stack']['name'] = stack

      node.set['docroot'] = 'public'
    end

    it 'includes necessary recipes' do
      expect(chef_run).to include_recipe 'nginx-app::server'
    end

    describe 'virtualhost' do
      before do
        node.set['deploy']['easybib'] = {
          'deploy_to' => '/srv/www/easybib'
        }
        node.set['nginx-app']['access_log'] = access_log
        node.set['php-fpm']['user'] = php_user
      end

      it "writes virtualhost for app 'easybib'" do
        expect(chef_run).to create_template(template_name)
          .with(
            :path => vhost,
            :source => 'easybib.com.conf.erb'
          )

        template_resource = chef_run.template(template_name)
        expect(template_resource).to notify('service[nginx]')
          .to(:restart)
          .delayed
      end

      it 'sets the correct root' do
        expect(chef_run).to render_file(vhost)
          .with_content(
            include('root /srv/www/easybib/current/public;')
          )
      end

      it 'sets the correct upstream' do
        expect(chef_run).to render_file(vhost)
          .with_content(
            include("unix:/var/run/php-fpm/#{node['php-fpm']['pools'][0]}")
          )
          .with_content(
            include('upstream easybib_phpfpm {')
          )
      end

      it 'sets the correct BIB_ENV' do
        expect(chef_run).to render_file(vhost)
          .with_content(
            include("fastcgi_param BIB_ENV \"#{stack}\";")
          )
      end

      it 'sets the correct SCRIPT_FILENAME' do
        expect(chef_run).to render_file(vhost)
          .with_content(
            include('fastcgi_param SCRIPT_FILENAME $document_root/index.php;')
          )
      end

      it 'sets the correct access_log' do
        expect(chef_run).to render_file(vhost)
          .with_content(
            include("access_log #{access_log};")
          )
      end

      describe 'infolit' do
        before do
          node.set['deploy']['infolit'] = {
            'deploy_to' => '/srv/www/infolit'
          }
        end

        it 'creates the virtualhost from the correct erb' do
          expect(chef_run).to create_template('render vhost: infolit')
            .with(
              :path => vhost,
              :source => 'infolit.conf.erb'
            )
        end
      end

      describe 'pools' do
        before do
          node.set['php-fpm']['pools'] = %w(www1 www2 www3)
        end

        it 'creates three upstreams' do
          node['php-fpm']['pools'].each do |pool_name|
            expect(chef_run).to render_file(vhost)
              .with_content(
                include("unix:/var/run/php-fpm/#{pool_name}")
              )
          end
        end
      end
    end

    describe 'fastcgi setup' do
      before do
        node.set['nginx-app']['fastcgi']['fastcgi_connect_timeout'] = 1500
      end

      it 'creates the configuration' do
        expect(chef_run).to create_template(fastcgi_conf)
      end

      it 'sets the correct fastcgi settings' do
        node['nginx-app']['fastcgi'].each do |k, v|
          expect(chef_run).to render_file(fastcgi_conf)
            .with_content(
              include("#{k} #{v};")
            )
        end
      end

      it 'injected the correct value into the template' do
        expect(chef_run).to render_file(fastcgi_conf)
          .with_content(
            include('fastcgi_connect_timeout 1500;')
          )
      end
    end
  end
end
