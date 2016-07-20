require_relative 'spec_helper.rb'

describe 'haproxy::configure' do
  let(:runner) do
    ChefSpec::Runner.new do |node|
      node.set[:opsworks][:stack][:name] = 'chefspec'
      node.set[:opsworks][:instance][:region][:id] = 'local'
      node.set[:opsworks][:layers][:nginxphpapp][:instances] = {
        'php-app-server-1' => {
          'private_dns_name' => 'php.app.server.1.tld'
        }
      }
      node.set[:opsworks][:layers][:nodeapp][:instances] = {
        'node-app-server-1' => {
          'private_dns_name' => 'node.app.server.1.tld'
        }
      }
      node.set[:haproxy] = {
        :ssl => 'on',
        :websocket_layers => {
          :nodeapp => {
            :port => 8123,
            :health_check => {
              :url => '/foo?bar=123',
              :host => 'ws.example.com'
            }
          }
        }
      }
    end
  end
  let(:chef_run) { runner.converge('haproxy::configure') }
  let(:node) { runner.node }
  let(:haproxy_cfg) { '/etc/haproxy/haproxy.cfg' }

  describe 'SSL is configured' do
    before do
      stub_command('pgrep haproxy').and_return(false)
    end

    it 'configures SSL' do
      expect(chef_run).to render_file(haproxy_cfg)
        .with_content(
          include('bind *:443 ssl crt /etc/nginx/ssl/cert.combined.pem')
        )
    end
  end

  describe 'redirect from http to https is configured' do
    before do
      stub_command('pgrep haproxy').and_return(false)
      node.set[:haproxy][:ssl] = 'only'
    end

    it 'contains the redirect' do
      expect(chef_run).to render_file(haproxy_cfg)
        .with_content(
          include('redirect scheme https if !{ ssl_fc }')
        )
    end
  end
end
