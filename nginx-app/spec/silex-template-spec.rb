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

  describe "enabled access log" do
    before do
      node.set["testdata"]["access_log"] = "/tmp.log"
    end

    it "sets correct access log path" do
      expect(chef_run).to render_file('/tmp/config.conf').with_content(/access_log \/tmp.log;/)
    end
  end

  describe "no routes enabled or disabled" do
    before do
      node.set["testdata"]["routes_enabled"] = nil
      node.set["testdata"]["routes_denied"]  = nil
    end

    it "does not deny any routes" do
      expect(chef_run).not_to render_file('/tmp/config.conf').with_content(/deny all;/)
    end

    it "does enable all routes" do
      expect(chef_run).to render_file('/tmp/config.conf').with_content(%r!location / {\n.*try_files \$uri \$uri/ @site;\n.*}!)
    end
  end

end
