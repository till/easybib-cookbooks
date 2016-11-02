require 'chefspec'

describe 'tsung::default' do

  let(:runner)   { ChefSpec::Runner.new(:version => 12.04) }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  let(:log_dir) { "/home/#{node['tsung']['user']}/.tsung/log" }

  describe 'precise' do
    it 'installs tsung' do
      expect(chef_run).to install_package('tsung')
    end

    it 'configures nginx' do
      expect(chef_run).to include_recipe 'nginx-app::server'
      expect(chef_run).to create_directory(log_dir)
      expect(chef_run).to render_file('/etc/nginx/sites-available/tsung')
        .with_content(
          include('access_log off;')
        )
    end
  end
end
