require_relative 'spec_helper'

describe 'silex-config-template' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../"),
      File.expand_path("#{File.dirname(__FILE__)}/")
    ]
  end

  let(:runner)   { ChefSpec::Runner.new(:cookbook_path => cookbook_paths) }
  let(:chef_run) { runner.converge('fixtures::silex-template') }
  let(:node)     { runner.node }
  let(:config_filename) { '/tmp/config.conf' }

  describe 'enabled access log' do
    before do
      node.override['testdata']['access_log'] = '/tmp.log'
    end

    it 'sets correct access log path' do
      expect(chef_run).to render_file(config_filename).with_content('access_log /tmp.log;')
    end
  end

  describe 'no routes enabled or disabled' do
    before do
      node.override['testdata']['routes_enabled'] = nil
      node.override['testdata']['routes_denied']  = nil
    end

    it 'does not deny any routes' do
      expect(chef_run).not_to render_file(config_filename)
        .with_content(some_routes_denied)
    end
  end

  describe 'php setup' do
    it 'does route / to php' do
      expect(chef_run).to render_file(config_filename)
        .with_content(slash_is_enabled)
    end

    it 'sets up fpm_status and fpm_ping' do
      upstream = 'foo' # see fixture::silex-template

      # this needs to be indented according to the partial
      fixture = "    location ~ ^/(fpm_status|fpm_ping)$ {\n"
      fixture << "        include      fastcgi_params;\n"
      fixture << "        fastcgi_pass #{upstream}_phpfpm;\n"
      fixture << "        allow        127.0.0.1;\n"
      fixture << "        deny         all;\n"
      fixture << "    }\n"

      expect(chef_run).to render_file(config_filename)
        .with_content(fixture)
    end
  end

  describe 'some routes enabled' do
    before do
      node.override['testdata']['routes_enabled'] = ['/some/route', '/other/route']
      node.override['testdata']['routes_denied']  = nil
      node.override['opsworks']['stack']['name']  = 'rspec'
    end

    it 'does set routes for enabled routes' do
      expect(chef_run).to render_file(config_filename)
        .with_content(default_route_for_partial_route('/some/route|/other/route'))
    end

    it 'does not deny any routes' do
      expect(chef_run).not_to render_file(config_filename)
        .with_content(some_routes_denied)
    end

    it 'does not route / to php' do
      expect(chef_run).not_to render_file(config_filename)
        .with_content(slash_is_enabled)
    end

    it 'does redirect / to another location' do
      expect(chef_run).to render_file(config_filename)
        .with_content(slash_is_redirected)
    end
  end

  describe 'some routes enabled including slash' do
    before do
      node.override['testdata']['routes_enabled'] = ['/some/route', '/other/route', '/']
      node.override['testdata']['routes_denied']  = nil
      node.override['opsworks']['stack']['name']  = 'rspec'
    end

    it 'does not redirect / to another location' do
      expect(chef_run).not_to render_file(config_filename)
        .with_content(slash_is_redirected)
    end
  end

  describe 'some routes disabled' do
    before do
      node.override['testdata']['routes_enabled'] = nil
      node.override['testdata']['routes_denied']  = ['/some/route', '/other/route']
    end

    it 'does not deny any routes' do
      expect(chef_run).to render_file(config_filename)
        .with_content('/some/route|/other/route')
    end

    it 'does route / to php' do
      expect(chef_run).to render_file(config_filename)
        .with_content(slash_is_enabled)
    end

    it 'does not redirect / to another location' do
      expect(chef_run).not_to render_file(config_filename)
        .with_content(slash_is_redirected)
    end
  end

  describe 'some routes enabled, some disabled' do
    before do
      node.override['testdata']['routes_enabled'] = ['/some/route', '/other/route']
      node.override['testdata']['routes_denied']  = ['/some/droute', '/other/droute']
      node.override['opsworks']['stack']['name']  = 'rspec'
    end

    it 'does set routes for enabled routes' do
      expect(chef_run).to render_file(config_filename)
        .with_content(default_route_for_partial_route('/some/route|/other/route'))
    end

    it 'does deny disabled routes' do
      expect(chef_run).to render_file(config_filename)
        .with_content(some_routes_denied('/some/droute|/other/droute'))
    end

    it 'does not route / to php' do
      expect(chef_run).not_to render_file(config_filename)
        .with_content(slash_is_enabled)
    end

    it 'does redirect / to another location' do
      expect(chef_run).to render_file(config_filename)
        .with_content(slash_is_redirected)
    end
  end

end

private

def slash_is_redirected(target = 'http://easybib.com/company/contact')
  %r!location = / {\s* return 301 #{target};\s*}!
end

def default_route_for_partial_route(routes = '.*')
  %r!location ~ \^/\(#{routes}\) {\s*location / {\s*try_files \$uri \$uri/ @site;\s*}!
end

def slash_is_enabled
  %r!location = / {\s*try_files @site @site;\s*}!
end

def some_routes_denied(routes = '.*')
  %r!location ~ \^/\(#{routes}\) {\s*deny all;\s*}!
end
