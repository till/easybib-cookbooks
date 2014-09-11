require 'chefspec'

describe 'composer::configure' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../")
    ]
  end

  let(:runner)   { ChefSpec::Runner.new(:cookbook_path => cookbook_paths) }
  let(:chef_run) { runner.converge("composer::configure") }
  let(:node)     { runner.node }

  describe "composer" do
    it "is not installed in vagrant" do
      expect(chef_run).not_to render_file("~/.composer/config.json")
    end
  end

  describe "composer" do
    before do
      node.set["opsworks"]["deploy_user"] = {
        "user" => "www-data",
        "group" => "www-data"
      }
      node.set["composer"]["oauth_key"] = "123-super-secret-key"
    end

    it "creates a config.json" do
      expect(chef_run).to render_file("/var/www/.composer/config.json")
        .with_content(
          include("123-super-secret-key")
        )
    end
  end
end
