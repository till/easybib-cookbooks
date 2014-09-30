require 'chefspec'

describe 'nginx-app::server' do

  let(:runner) do
    ChefSpec::Runner.new(
      :step_into => ['nginx_app_config'],
      :version => 12.04
    )
  end
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  describe 'nginx-app server install' do
    before do
      stub_command('rm -f /etc/nginx/sites-enabled/default').and_return(true)
    end

    it 'installs nginx' do
      expect(chef_run).to include_recipe('nginx-app::ppa')
      expect(chef_run).to include_recipe('nginx-app::service')
      expect(chef_run).to install_package('nginx')

      install_package = chef_run.package('nginx')
      expect(install_package).to notify('ohai[reload_passwd]').to(:reload).immediately
      expect(install_package).to notify('service[nginx]').to(:enable)
      expect(install_package).to notify('service[nginx]').to(:start)
    end

    it 'configures nginx' do
      expect(chef_run).to create_template('/etc/nginx/fastcgi_params')
      expect(chef_run).to create_template('/etc/nginx/nginx.conf')
      expect(chef_run).to run_execute('delete default vhost')
    end
  end
end
