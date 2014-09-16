require_relative "spec_helper"

describe 'easybib_deploy' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../"),
      File.expand_path("#{File.dirname(__FILE__)}/")
    ]
  end

  let(:runner) do
    ChefSpec::Runner.new(
      cookbook_path: cookbook_paths,
      step_into: ["easybib_deploy"]
    )
  end

  let(:node) { runner.node }

  let(:chef_run) { runner.converge("fixtures::easybib_deploy") }

  describe "deploy" do
    it "creates a robots.txt" do
      expect(chef_run).to create_cookbook_file("/srv/www/some-app/current/public/robots.txt")
    end
  end
end
