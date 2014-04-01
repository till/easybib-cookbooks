require_relative "spec_helper"

describe 'silex-config-template' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../"),
      File.expand_path("#{File.dirname(__FILE__)}/")
    ]
  end

  let(:runner)   { ChefSpec::Runner.new(:cookbook_path => cookbook_paths) }
  let(:chef_run) { runner.converge("fixtures::silex-template") }
  let(:node)     { runner.node }
  let(:config_filename) { '/tmp/config.conf' }

  describe "enabled access log" do
    before do
      node.set["testdata"]["access_log"] = "/tmp.log"
    end

    it "sets correct access log path" do
      expect(chef_run).to render_file(config_filename).with_content(/access_log \/tmp.log;/)
    end
  end

  describe "no routes enabled or disabled" do
    before do
      node.set["testdata"]["routes_enabled"] = nil
      node.set["testdata"]["routes_denied"]  = nil
    end

    it "does not deny any routes" do
      expect(chef_run).not_to render_file(config_filename).with_content(some_routes_denied)
    end
    it "does route / to php" do
      expect(chef_run).to render_file(config_filename).with_content(slash_is_enabled)
    end
  end

  describe "some routes enabled" do
    before do
      node.set["testdata"]["routes_enabled"] = ['/some/route']
      node.set["testdata"]["routes_denied"]  = nil
    end

    it "does not deny any routes" do
      expect(chef_run).not_to render_file(config_filename).with_content(some_routes_denied)
    end

    it "does not route / to php" do
      expect(chef_run).not_to render_file(config_filename).with_content(slash_is_enabled)
    end

    it "does redirect / to another location" do
      expect(chef_run).to render_file(config_filename).with_content(slash_is_redirected)
    end
  end

  let(:slash_is_redirected)          { %r!location = / {\s* return 301 http://easybib.com/company/contact;\s*}! }
  let(:default_route_for_some_route) { %r!location ~ /(.*) {\s*location / {\s*try_files $uri $uri/ @site;\s*}! }
  let(:slash_is_enabled)             { %r!location = / {\s*try_files @site @site;\s*}! }
  let(:some_routes_denied)           { %r!location ~ /(.*) {\s*deny all;\s*}! }

end
