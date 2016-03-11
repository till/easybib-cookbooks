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

  let(:node) { runner.node }

  let(:chef_run) { runner.converge('fixtures::easybib_supervisor_create_with_orphan') }

  describe 'easybib_supervisor' do
    describe 'create' do
      before do
        stub_supervisor_with_one_service_and_one_orphan
        node.set['opsworks'] = {} # to have is_aws true
      end

      it 'enables the first supervisor' do
        expect(chef_run).to enable_supervisor_service('service1-some-app')
          .with(
            :command => '/foo/bar/service1cmd',
            :user => 'some-user'
          )
        expect(chef_run).to restart_supervisor_service('service1-some-app')
      end

      it 'deletes the orphan supervisor' do
        expect(chef_run).to stop_supervisor_service('oprphan-service-some-app:*')
        expect(chef_run).to disable_supervisor_service('oprphan-service-some-app')
      end
    end
  end
end

def stub_supervisor_with_one_service_and_one_orphan
  ::File.stub(:exist?).with(anything).and_call_original
  ::File.stub(:exist?).with('/deploy/supervisor.json').and_return true
  
  ::File.stub(:exist?).with('/etc/supervisor.d/oprphan-service-some-app.conf').and_return true

  ::File.stub(:read).with(anything).and_call_original
  ::File.stub(:read).with('/deploy/supervisor.json').and_return '{
    "service1": {"command": "service1cmd"}
  }'
end
