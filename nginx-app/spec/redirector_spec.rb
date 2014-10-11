require 'chefspec'

describe 'nginx-app::redirector' do

  let(:runner) do
    ChefSpec::Runner.new(
      :step_into => ['nginx_app_config'],
      :version => 12.04
    )
  end
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  let(:vhost) { "/etc/nginx/sites-enabled/redir-example.org.conf" }

  describe 'setup domain redirect' do
    before do
      node.set['redirector']['domains'] = {
        'example.org' => 'example.com'
      }
    end

    it 'uses the template' do
      expect(chef_run).to create_template(vhost)
    end

    it 'it sets up the redirect' do
      expect(chef_run).to render_file(vhost)
        .with_content(
          include('server_name example.org;')
        )
        .with_content(
          include('rewrite ^ http://example.com$request_uri? permanent;')
        )
    end
  end
end
