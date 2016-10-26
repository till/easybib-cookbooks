require 'chefspec'

describe 'stack-scholar::deploy' do

  let(:runner) do
    ChefSpec::Runner.new(
      :log_level => :error,
      :step_into => %w(easybib_deploy_manager nginx_app_config easybib_nginx)
    )
  end
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  let(:vhost) { '/etc/nginx/sites-enabled/scholar.conf' }
  let(:stack) { 'Stack Name' }
  let(:domain) { 'scholar.example.org' }
  let(:conf_name) { 'scholar.conf.erb' }

  describe 'scholar nginx' do
    before do

      stub_command('rm -f /etc/nginx/sites-enabled/default').and_return(true)

      node.override['easybib']['cluster_name'] = stack

      node.override['opsworks']['instance']['layers'] = ['nginxphpapp']
      node.override['opsworks']['stack']['name'] = stack

      node.override['deploy']['scholar'] = {
        'deploy_to' => '/srv/www/scholar',
        'document_root' => 'docroot',
        'domains' => [domain]
      }

      node.override['infolit']['domain'] = domain
    end

    it 'creates the virtualhost from the correct erb' do
      expect(chef_run).to create_template(vhost)
        .with(
          :path => vhost,
          :source => conf_name
        )
    end
  end
end
