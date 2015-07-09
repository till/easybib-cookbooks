require_relative 'spec_helper'

describe 'easybib_supervisor-without-matching-role' do

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

  let(:chef_run) { runner.converge('fixtures::easybib_supervisor_without_matching_role') }

  describe 'easybib_supervisor without matching role' do
    describe 'create' do
      before { stub_supervisor_with_two_services }

      it 'does not proceed' do
        expect(chef_run).not_to enable_supervisor_service('service1-some-app')
      end
    end
  end
end

def stub_supervisor_with_two_services
  ::File.stub(:exist?).with(anything).and_call_original
  ::File.stub(:exist?).with('/some_file').and_return true

  ::File.stub(:read).with(anything).and_call_original
  ::File.stub(:read).with('/some_file').and_return '{
    "service1": {"command": "service1cmd"},
    "service2": {"command": "service2cmd"}
  }'
end
