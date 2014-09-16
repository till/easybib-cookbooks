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
      log_level: :debug,
      step_into: ["easybib_deploy"]
    )
  end

  let(:node) { runner.node }

  let(:chef_run) { runner.converge("fixtures::easybib_deploy") }

  #let(:easybib_crontab_stub) { double('easybib_crontab') }
  #let(:opsworks_deploy_stub) { double('opsworks_deploy') }
  #let(:opsworks_deploy_dir_stub) { double('opsworks_deploy_dir') }
  #let(:opsworks_deploy_user_stub) { double('opsworks_deploy_user') }

  describe "deploy" do
    before do
      #Chef::Resource::EasybibCrontab.stub(:new).and_return(easybib_crontab_stub)
      #Chef::Resource::OpsworksDeploy.stub(:new).and_return(opsworks_deploy_stub)
      #Chef::Resource::OpsworksDeployDir.stub(:new).and_return(opsworks_deploy_dir_stub)
      #Chef::Resource::OpsworksDeployUser.stub(:new).and_return(opsworks_deploy_user_stub)
    end

    it "creates a robots.txt" do
      expect(chef_run).to create_cookbook_file("/srv/www/some-app/current/public/robots.txt")
    end
  end
end
