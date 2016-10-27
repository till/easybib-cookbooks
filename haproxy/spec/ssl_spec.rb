require_relative 'spec_helper.rb'

describe 'haproxy::configure' do
  let(:runner) do
    ChefSpec::SoloRunner.new do |node|
      node.override[:opsworks][:stack][:name] = 'chefspec'
      node.override[:opsworks][:instance][:region][:id] = 'local'
      node.override[:opsworks][:layers][:nginxphpapp][:instances] = {
        'php-app-server-1' => {
          'private_dns_name' => 'php.app.server.1.tld'
        }
      }
      node.override[:opsworks][:layers][:nodeapp][:instances] = {
        'node-app-server-1' => {
          'private_dns_name' => 'node.app.server.1.tld'
        }
      }
      node.override[:haproxy] = {
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

  describe 'SSL' do
    before do
      stub_command('pgrep haproxy').and_return(false)
    end

    describe 'enabled' do
      it 'configures SSL' do
        expect(chef_run).to render_file(haproxy_cfg)
          .with_content(
            include('bind *:443 ssl crt /etc/nginx/ssl/cert.combined.pem')
          )
      end
    end

    describe 'only' do
      before do
        node.override[:haproxy][:ssl] = 'only'
      end

      it 'redirects all http to https' do
        expect(chef_run).to render_file(haproxy_cfg)
          .with_content(
            include('redirect scheme https if !{ ssl_fc }')
          )
      end
    end

    describe 'disabled' do
      before do
        node.override[:haproxy][:ssl] = 'off'
      end

      it 'does not bind to 443' do
        expect(chef_run).to render_file(haproxy_cfg)
        expect(chef_run).not_to render_file(haproxy_cfg)
          .with_content(include('bind *:443'))
      end
    end
  end
end
