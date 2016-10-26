require_relative 'spec_helper'

describe 'easybib_supervisor - explicit attrs' do

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

  let(:chef_run) { runner.converge('fixtures::easybib_supervisor_explicit_attributes') }

  describe 'easybib_supervisor actions on aws' do
    describe 'create' do
      before do
        stub_supervisor_with_two_services
        node.override['opsworks'] = {} # to have is_aws true
      end

      it 'enables the first service' do
        expect(chef_run).to enable_supervisor_service('service1-some-app')
          .with(
            :command => '/foo/bar/service1cmd',
            :user => 'some-user'
          )
        expect(chef_run).to restart_supervisor_service('service1-some-app')
      end
      it 'enables the second service' do
        expect(chef_run).to enable_supervisor_service('service2-some-app')
          .with(
            :command => '/foo/bar/service2cmd',
            :user => 'some-user'
          )
        expect(chef_run).to restart_supervisor_service('service2-some-app')
      end
    end
  end

  describe 'easybib_supervisor without file' do
    describe 'create' do
      before do
        stub_supervisor_does_not_exist
      end

      it 'does not proceed' do
        expect(chef_run).not_to enable_supervisor_service('service1-some-app')
      end
    end
  end
end

describe 'easybib_supervisor - implicit attrs' do

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

  let(:chef_run) { runner.converge('fixtures::easybib_supervisor_implicit_attributes') }

  describe 'easybib_supervisor actions on aws' do
    describe 'create' do
      before do
        stub_supervisor_with_two_services
        node.override['opsworks']['instance']['layers'] = %w(role1 role2)
        node.override['easybib_deploy']['supervisor_role'] = 'role1'
      end

      it 'enables the first service' do
        expect(chef_run).to enable_supervisor_service('service1-some-app')
          .with(
            :command => '/foo/bar/service1cmd',
            :user => 'some-user'
          )
        expect(chef_run).to restart_supervisor_service('service1-some-app')
      end
      it 'enables the second service' do
        expect(chef_run).to enable_supervisor_service('service2-some-app')
          .with(
            :command => '/foo/bar/service2cmd',
            :user => 'some-user'
          )
        expect(chef_run).to restart_supervisor_service('service2-some-app')
      end
    end
  end

  describe 'easybib_supervisor actions on vagrant' do
    describe 'create' do
      before do
        stub_supervisor_with_two_services
        node.override['easybib_deploy']['supervisor_role'] = 'role1'
      end

      it 'enables the first service' do
        expect(chef_run).to enable_supervisor_service('service1-some-app')
          .with(
            :command => '/foo/bar/service1cmd',
            :user => 'some-user'
          )
        expect(chef_run).to restart_supervisor_service('service1-some-app')
      end
      it 'enables the second service' do
        expect(chef_run).to enable_supervisor_service('service2-some-app')
          .with(
            :command => '/foo/bar/service2cmd',
            :user => 'some-user'
          )
        expect(chef_run).to restart_supervisor_service('service2-some-app')
      end
    end
  end

  describe 'easybib_supervisor without file' do
    describe 'create' do
      before do
        stub_supervisor_does_not_exist
        node.override['opsworks']['instance']['layers'] = %w(role1 role2)
        node.override['easybib_deploy']['supervisor_role'] = 'role1'
      end

      it 'does not proceed' do
        expect(chef_run).not_to enable_supervisor_service('service1-some-app')
      end
    end
  end
end

def stub_supervisor_does_not_exist
  ::File.stub(:exist?).with(anything).and_call_original
  ::File.stub(:exist?).with('/some_file').and_return false
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
