require_relative 'spec_helper.rb'

describe 'stack-easybib::role-nginxphpapp' do

  let(:runner) do
    ChefSpec::Runner.new(
      :step_into => ['easybib_nginx']
    )
  end
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  let(:vhost) { '/etc/nginx/sites-enabled/easybib.conf' }
  let(:access_log) { '/some/drive/access.log' }
  let(:stack) { 'Stack Name' }
  let(:template_name) { '/etc/nginx/sites-enabled/easybib.conf' }
  let(:fastcgi_conf) { '/etc/nginx/fastcgi_params' }

  describe 'deployment' do
    before do
      stub_command('rm -f /etc/nginx/sites-enabled/default').and_return(true)
      node.set['deploy']                    = {}
      node.set['easybib']['cluster_name']   = stack
      node.set['opsworks']['stack']['name'] = stack
      node.set['opsworks']['instance']      = {
        'layers' => ['nginxphpapp'],
        'hostname' => 'hostname',
        'ip' => '127.0.0.1'
      }
    end

    describe 'virtualhost' do
      before do
        node.set['deploy']['easybib'] = {
          'deploy_to' => '/srv/www/easybib',
          'document_root' => 'public'
        }
        node.set['nginx-app']['access_log'] = access_log
      end

      it "writes virtualhost for app 'easybib'" do
        expect(chef_run).to create_template(template_name)
          .with(
            :path => vhost,
            :source => 'easybib.com.conf.erb'
          )

        template_resource = chef_run.template(template_name)
        expect(template_resource).to notify('execute[nginx_configtest_easybib]')
          .to(:run)
          .immediately
      end

      it 'sets the correct root' do
        expect(chef_run).to render_file(vhost)
          .with_content(
            include('default /srv/www/easybib/current/public/;')
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

      it 'not not configure access-logging' do
        expect(chef_run).to_not render_file(vhost)
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
