require_relative 'spec_helper'

describe 'easybib_supervisor-without-matching-role' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../"),
      File.expand_path("#{File.dirname(__FILE__)}/")
    ]
  end

  let(:runner) do
    ChefSpec::SoloRunner.new(
      :cookbook_path => cookbook_paths,
      :step_into => ['easybib_supervisor']
    )
  end

  let(:node) { runner.node }

  let(:chef_run) { runner.converge('fixtures::easybib_supervisor_without_matching_role') }

  describe 'easybib_supervisor without matching role, set explicit in cookbook' do
    describe 'create' do
      before do
        stub_supervisor_with_two_services
        node.override['opsworks'] = {} # to have is_aws true
      end

      it 'does not proceed' do
        expect(chef_run).not_to enable_supervisor_service('service1-some-app')
      end
    end
  end
end

describe 'easybib_supervisor-without-matching-role-implicit' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../"),
      File.expand_path("#{File.dirname(__FILE__)}/")
    ]
  end

  let(:runner) do
    ChefSpec::SoloRunner.new(
      :cookbook_path => cookbook_paths,
      :step_into => ['easybib_supervisor']
    )
  end

  let(:node) { runner.node }

  let(:chef_run) { runner.converge('fixtures::easybib_supervisor_implicit_attributes') }

  describe 'easybib_supervisor without matching role, roles fetched from json' do
    describe 'create' do
      before do
        stub_supervisor_with_two_services
        node.override['opsworks']['instance']['layers'] = %w(role1 role2)
        node.override['easybib_deploy']['supervisor_role'] = 'some-other-role'
      end

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
