require_relative "spec_helper"

describe 'easybib_gearmanw' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../"),
      File.expand_path("#{File.dirname(__FILE__)}/")
    ]
  end

  let(:runner) do
    ChefSpec::Runner.new(
      :cookbook_path => cookbook_paths,
      :step_into => ["easybib_gearmanw"]
    )
  end

  let(:node) { runner.node }

  let(:chef_run) { runner.converge("fixtures::easybib_gearmanw") }

  describe "easybib_gearmanw actions" do
    context "create with existing peclmanager file" do
      before { stub_gearmanw_file_existing }

      it "sets up pecl manager script" do
        expect(chef_run).to create_pecl_manager_script("Setting up Pecl Manager")
          .with(
          :dir => "/some_dir",
          :envvar_file => "/some_dir/deploy/pecl_manager_env",
          :envvar_json_source => "some-source"
        )
      end
    end

    context "create with non-existing peclmanager file" do
      before { stub_gearmanw_file_not_existing }

      it "sets up pecl manager script" do
        expect(chef_run).not_to create_pecl_manager_script("Setting up Pecl Manager")
      end
    end
  end
end

def stub_gearmanw_file_existing
  ::File.stub(:exist?).with(anything).and_call_original
  ::File.stub(:exist?).with('/some_dir/deploy/pecl_manager_env').and_return true
end

def stub_gearmanw_file_not_existing
  ::File.stub(:exist?).with(anything).and_call_original
  ::File.stub(:exist?).with('/some_dir/deploy/pecl_manager_env').and_return false
end
