require 'chefspec'

describe 'easybib-deploy::internal-api' do

  let(:runner) do
    ChefSpec::Runner.new(
      :step_into => %w(nginx_app_config easybib_nginx)
    )
  end
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  let(:vhost) { '/etc/nginx/sites-enabled/highbeam.conf' }
  let(:access_log) { '/some/drive/access.log' }
  let(:stack) { 'Stack Name' }
  let(:template_name) { '/etc/nginx/sites-enabled/highbeam.conf' }
  let(:fastcgi_conf) { '/etc/nginx/fastcgi_params' }

  describe 'deployment' do
    before do
      stub_command('rm -f /etc/nginx/sites-enabled/default').and_return(true)

      node.set['deploy'] = {}

      node.set['easybib']['cluster_name'] = stack

      node.set['opsworks']['instance']['layers'] = ['highbeam']
      node.set['opsworks']['stack']['name'] = stack
    end

    describe 'virtualhost' do
      before do
        node.set['deploy']['highbeam'] = {
          'deploy_to' => '/srv/www/highbeam',
          'document_root' => 'public',
          'domains' => ['foo.tld']
        }
      end

      it "writes virtualhost for app 'easybib'" do
        expect(chef_run).to create_template(template_name)
          .with(
            :path => vhost,
            :source => 'internal-api.conf.erb'
          )
      end

      it 'sets the correct root' do
        expect(chef_run).to render_file(vhost)
          .with_content(
            include('root /srv/www/highbeam/current/public/;')
          )
      end

      it 'sets the correct upstream' do
        expect(chef_run).to render_file(vhost)
          .with_content(
            include("unix:/var/run/php-fpm/#{node['php-fpm']['pools'][0]}")
          )
          .with_content(
            include('upstream highbeam_phpfpm {')
          )
      end

      it 'sets the correct SCRIPT_FILENAME' do
        expect(chef_run).to render_file(vhost)
          .with_content(
            include('fastcgi_param SCRIPT_FILENAME $document_root/index.php;')
          )
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

  end
end
