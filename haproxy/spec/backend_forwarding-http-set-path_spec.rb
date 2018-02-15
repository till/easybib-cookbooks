require_relative 'spec_helper.rb'

describe 'haproxy::configure' do
  let(:runner) do
    ChefSpec::Runner.new do |node|
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
            :http_match_path => '/some-random-path/there.html',
            :http_set_path => '/some-random-path/here.html',
            :http_set_host => 'set.host.tld',
            :haproxy_check_interval => '60000',
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

  describe 'forward servers with set path - check settings' do
    before do
      stub_command('pgrep haproxy').and_return(false)
    end

    it 'Configures haproxy with http-request set-path when defined' do

      expect(chef_run).to create_template('/etc/haproxy/haproxy.cfg').with(
        :user => 'root',
        :group => 'root',
        :mode => 0644
      )

      expect(chef_run).to render_file('/etc/haproxy/haproxy.cfg').with_content(
        'reqirep ^([^\ ]*)\ /some-random-path/there.html\ (.*)$ \1\ /some-random-path/here.html\ \2'
      )

    end
    it 'Configures haproxy with http-request set-header Host' do

      expect(chef_run).to render_file('/etc/haproxy/haproxy.cfg').with_content(
        'http-request set-header Host set.host.tld'
      )

    end
    it 'Configures haproxy with custom interval' do

      expect(chef_run).to render_file('/etc/haproxy/haproxy.cfg').with_content(
        'server second-app-www1 second.app1.tld:80 weight 10 maxconn 255 rise 2 fall 3 check inter 60000'
      )

    end
  end
end
