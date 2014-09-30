require_relative 'spec_helper'

describe 'easybib_nginx getcourse static' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../"),
      File.expand_path("#{File.dirname(__FILE__)}/")
    ]
  end

  let(:runner) do
    ChefSpec::Runner.new(
      :cookbook_path => cookbook_paths,
      :step_into => ['easybib_nginx']
    )
  end
  let(:chef_run) { runner.converge('fixtures::easybib_nginx') }
  let(:node)     { runner.node }

  let(:nginx_config_file) { '/etc/nginx/sites-enabled/domainadmin.conf' }

  describe 'gzip is not enabled' do
    before do
      node.set['vagrant'] = {
        'combined' => true,
        'deploy_to' => '/foo/bar'
      }
      node.set['getcourse']['domain'] = {
        'domainadmin' => 'manage.example.org'
      }
    end

    it 'does not enable gzip' do
      expect(chef_run).to render_file(nginx_config_file)
        .with_content(
          include('gzip off;')
        )
    end
  end

  describe 'gzip is enabled' do
    before do
      node.set['vagrant'] = {
        'combined' => true,
        'deploy_to' => '/foo/bar'
      }
      node.set['nginx-app']['gzip']['enabled'] = true
      node.set['nginx-app']['gzip']['config']['comp_level'] = 9999
      node.set['getcourse']['domain'] = {
        'domainadmin' => 'manage.example.org'
      }
    end

    it 'does enable gzip' do
      expect(chef_run).to render_file(nginx_config_file)
        .with_content(
          include('gzip on;')
        )
    end

    it 'does set the correct gzip_comp_level' do
      expect(chef_run).to render_file(nginx_config_file)
        .with_content(
          include('gzip_comp_level 9999;')
        )
    end
  end
end
