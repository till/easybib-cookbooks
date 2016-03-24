require 'chefspec'

describe 'stack-citationapi::role-publicapi' do

  let(:runner) do
    ChefSpec::Runner.new(
      :step_into => ['easybib_nginx']
    )
  end
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  let(:access_log) { '/some/drive/access.log' }
  let(:stack) { 'Stack Name' }
  let(:template_name) { '/etc/nginx/sites-enabled/easybib_api.conf' }
  let(:fastcgi_conf) { '/etc/nginx/fastcgi_params' }

  describe 'deployment' do
    before do
      stub_command('rm -f /etc/nginx/sites-enabled/default').and_return(true)
      # DEBUG: why isnt ohai doing this? maybe some setup missing
      node.set['lsb']['codename'] = 'trusty'
      node.set['deploy'] = {}
      node.set['easybib']['cluster_name'] = stack
      node.set['opsworks']['stack']['name'] = stack
      node.set['opsworks']['instance'] = {
        'layers' => ['bibapi'],
        'hostname' => 'hostname',
        'ip' => '127.0.0.1'
      }
    end

    describe 'virtualhost' do
      before do
        node.set['deploy']['easybib_api'] = {
          'deploy_to' => '/srv/www/easybib_api',
          'document_root' => 'public'
        }
        node.set['nginx-app']['access_log'] = access_log
      end

      it "writes virtualhost for api 'data'" do
        expect(chef_run).to create_template(template_name)
          .with(
            :path => template_name,
            :source => 'formatting-api.conf.erb'
          )

        template_resource = chef_run.template(template_name)
        expect(template_resource).to notify('execute[nginx_configtest_easybib_api]')
          .to(:run)
          .immediately
      end

      it 'sets the correct root' do
        expect(chef_run).to render_file(template_name)
          .with_content(
            include('root /srv/www/easybib_api/current/public/;')
          )
      end

      it 'sets the correct upstream' do
        expect(chef_run).to render_file(template_name)
          .with_content(
            include("unix:/var/run/php-fpm/#{node['php-fpm']['pools'][0]}")
          )
          .with_content(
            include('upstream easybib_api_phpfpm {')
          )
      end

      it 'sets the correct SCRIPT_FILENAME' do
        expect(chef_run).to render_file(template_name)
          .with_content(
            include('fastcgi_param SCRIPT_FILENAME $document_root/index.php;')
          )
      end

      it 'not not configure access-logging' do
        expect(chef_run).to_not render_file(template_name)
          .with_content(
            include("access_log #{access_log};")
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
end
