require 'chefspec'

describe 'haproxy::configure' do
  let(:runner) do
    ChefSpec::Runner.new do |node|
      node.set[:opsworks][:layers][:nginxphpapp][:instances] = {}
      node.set[:opsworks][:layers][:app1][:instances] = {}
      node.set[:opsworks][:layers][:app2][:instances] = {}
      node.set[:haproxy] = {
        :acls => {},
        :additional_layers => {
          :app1 => {
            :acl => {
              :acl1 => 'hdr_dom(host) -i app1'
            },
            :health_check => 'GET /health_check HTTP/1.1\\r\\nHost:\\ app1.tld'
          },
          :app2 => {
            :acl => {
              :acl1 => 'hdr_dom(host) -i app2'
            },
            :health_check => {
              :url => '/url',
              :host => 'app2.tld'
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

  describe 'standard settings' do
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
        'httpchk GET /health_check HTTP/1.1\\r\\nHost:\\ app1.tld'
      )

      expect(chef_run).to render_file('/etc/haproxy/haproxy.cfg').with_content(
        'httpchk GET /url HTTP/1.1\\r\\nHost:\\ app2.tld'
      )

    end
  end
end
