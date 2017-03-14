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
      node.override['deploy'] = {}
      node.override['easybib']['cluster_name'] = stack
      node.override['opsworks']['stack']['name'] = stack
      node.override['opsworks']['instance'] = {
        'layers' => ['nginxphpapp'],
        'hostname' => 'hostname',
        'ip' => '127.0.0.1'
      }
    end

    describe 'virtualhost' do
      before do
        node.override['deploy']['easybib'] = {
          'deploy_to' => '/srv/www/easybib',
          'document_root' => 'public'
        }
        node.override['nginx-app']['access_log'] = access_log
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
    end
  end
end
