require_relative 'spec_helper'

describe 'easybib_supervisor - disable' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../"),
      File.expand_path("#{File.dirname(__FILE__)}/")
    ]
  end

  let(:runner) do
    ChefSpec::Runner.new(
      :cookbook_path => cookbook_paths,
      :step_into => ['easybib_supervisor']
    )
  end

  # supervisor.json 1 service
  # 2 supervisor commands running on the server

  let(:node) { runner.node }

  let(:chef_run) { runner.converge('fixtures::easybib_supervisor_disable') }

  describe 'easybib_supervisor' do
    describe 'delete' do
      before do
        stub_supervisor_with_one_service
        node.set['opsworks'] = {} # to have is_aws true
      end

      it 'deletes all supervisors' do
        expect(chef_run).to stop_supervisor_service('service1-some-app:*')
        expect(chef_run).to disable_supervisor_service('service1-some-app')
      end
    end
  end
end

def stub_supervisor_does_not_exist
  ::File.stub(:exist?).with(anything).and_call_original
  ::File.stub(:exist?).with('/some_file').and_return false
end

def stub_supervisor_with_one_service
  ::File.stub(:exist?).with(anything).and_call_original
  ::File.stub(:exist?).with('/deploy/supervisor.json').and_return true

  ::File.stub(:read).with(anything).and_call_original
  ::File.stub(:read).with('/deploy/supervisor.json').and_return '{
    "service1": {"command": "service1cmd"}
  }'
end
