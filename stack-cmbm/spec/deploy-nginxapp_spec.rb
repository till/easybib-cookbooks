require_relative 'spec_helper.rb'
require 'set'

describe 'stack-cmbm::deploy-nginxapp' do
  let(:runner) do
    ChefSpec::SoloRunner.new(
      :step_into => %w(ies_rbenv_deploy easybib_nginx)
    )
  end

  let(:chef_run)  { runner.converge(described_recipe) }
  let(:node)      { runner.node }

  let(:app_config_shortname) { 'cm' }
  let(:template_name) { "/etc/nginx/sites-enabled/#{app_config_shortname}.conf" }

  before do
    node.override['opsworks']['instance']['layers'] = ['nginxapp_cm']
    node.override[:deploy][:cm] = {
      :application => 'cm',
      :deploy_to => '/srv/cm',
      :deploy_dir => '/srv/cm',
      :document_root => 'www',
      :env => {
        :ruby => {
          :version => '2.2.3'
        }
      }
    }
    node.override[:etc][:passwd]['www-data'][:dir] = '/srv/www/cm'   # because OHAI is not around
  end

  it 'includes all required recipes' do
    expect(chef_run).to include_recipe('nginx-app::server')
    expect(chef_run).to include_recipe('supervisor')
  end

  it 'installs ruby via ies-rbenv' do
    expect(chef_run).to install_ies_rbenv_deploy('deploy ruby')
  end

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
        include('root /srv/cm/current/www/;')
      )
  end
end
