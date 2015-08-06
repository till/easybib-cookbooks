require 'chefspec'

describe 'nginx-app::redirector-ssl' do

  let(:runner) do
    ChefSpec::Runner.new(
      :step_into => ['nginx_app_config', 'easybib-deploy::sslcertificate'],
      :version => 14.04
    )
  end
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  let(:conf_dir) { '/etc/nginx/sites-enabled' }
  let(:vhost_redir) { "#{conf_dir}/redir-example.org-ssl.conf" }

  describe 'setup domain redirect without ssl' do
    before do
      node.set['redirector']['domains'] = {
        'example.org' => 'example.com'
      }
      node.set['deploy']['redirector'] = {}
    end

    it 'does not render ssl' do
      expect(chef_run).not_to create_template(vhost_redir)
    end
  end
  describe 'setup domain redirect with ssl certs' do
    before do
      node.set['redirector']['domains'] = {
        'example.org' => 'example.com'
      }
      node.set['deploy']['redirector'] = {
        'ssl_certificate' => 'RANDOMCHARACTERS',
        'ssl_certificate_key' => 'MORERANDOMCHARACTERS',
        'domains' => ['example.org', 'foo.org']
      }
    end

    it 'it sets up the redirect' do
      expect(chef_run).to render_file(vhost_redir)
        .with_content(
          include('server_name example.org;')
        )
        .with_content(
          include('rewrite ^ https://example.com$request_uri? permanent;')
        )
    end
  end
end
