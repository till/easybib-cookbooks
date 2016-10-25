require_relative 'spec_helper.rb'

describe 'haproxy::configure' do
  let(:runner) do
    ChefSpec::SoloRunner.new do |node|
      node.override[:opsworks][:stack][:name] = 'chefspec'
      node.override[:opsworks][:instance][:region][:id] = 'local'
      node.override[:opsworks][:layers][:nginxphpapp][:instances] = {}
      node.override[:opsworks][:layers][:app1][:instances] = {}
      node.override[:opsworks][:layers][:app2][:instances] = {}
      node.override[:haproxy] = {
        :acls => {},
        :forwarding_layers => {
          :app2 => {
            :acl => {
              :acl1 => 'hdr_dom(host) -i app2'
            },
            :health_check => {
              :url => '/url',
              :host => 'app2.tld'
            },
            :servers => {
              'second-app-www1' => 'second.app1.tld',
              'second-app-www2' => 'second.app2.tld'
            }
          }
        },
        :health_check_method => 'GET',
        :health_check_url => '/health'
      }
    end
  end
  let(:chef_run) { runner.converge('haproxy::configure') }
  let(:node) { runner.node }

  describe 'forward servers set - check settings' do
    before do
      stub_command('pgrep haproxy').and_return(false)
    end

    it 'Configures haproxy' do

      expect(chef_run).to create_template('/etc/haproxy/haproxy.cfg').with(
        :user => 'root',
        :group => 'root',
        :mode => 0644
      )

      expect(chef_run).to render_file('/etc/haproxy/haproxy.cfg').with_content(
        'backend app2_forward'
      )

      expect(chef_run).to render_file('/etc/haproxy/haproxy.cfg').with_content(
        'server second-app-www1 second.app1.tld:80'
      )

      expect(chef_run).to render_file('/etc/haproxy/haproxy.cfg').with_content(
        'server second-app-www2 second.app2.tld:80'
      )

    end
  end
end
