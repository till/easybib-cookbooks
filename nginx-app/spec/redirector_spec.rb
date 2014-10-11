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

  let(:conf_dir) { '/etc/nginx/sites-enabled' }
  let(:vhost_redir) { "#{conf_dir}/redir-example.org.conf" }
  let(:vhost_urls) { "#{conf_dir}/urls-john-doe.example.org.conf" }

  describe 'setup domain redirect' do
    before do
      node.set['redirector']['domains'] = {
        'example.org' => 'example.com'
      }
    end

    it 'uses the template' do
      expect(chef_run).to create_template(vhost_redir)
    end

    it 'it sets up the redirect' do
      expect(chef_run).to render_file(vhost_redir)
        .with_content(
          include('server_name example.org;')
        )
        .with_content(
          include('rewrite ^ http://example.com$request_uri? permanent;')
        )
    end
  end

  describe 'setup links to redirect' do
    before do
      node.set['redirector']['urls'] = {
        'john-doe.example.org' => {
          '/foo' => 'http://example.org/bar',
          '/' => 'http://example.com',
          '/bar' => 'http://example.com/bar'
        }
      }
    end

    it 'sets the john-doe.example.org server_name' do
      expect(chef_run).to create_template(vhost_urls)
    end

    it 'adds a map and sets the rewrite rule' do
      node['redirector']['urls'].each do |domain_name, locations|
        expect(chef_run).to render_file("#{conf_dir}/urls-#{domain_name}.conf")
          .with_content(
            include("server_name #{domain_name};")
          )
          .with_content(
            include('map $uri $new {')
          )
          .with_content(
            include('rewrite ^ $new permanent;')
          )

        locations.each do |from, to|
          expect(chef_run).to render_file("#{conf_dir}/urls-#{domain_name}.conf")
            .with_content(
              include("#{from} #{to};")
            )
        end
      end
    end
  end
end
