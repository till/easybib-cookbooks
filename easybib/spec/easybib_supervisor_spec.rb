require_relative 'spec_helper'

describe 'easybib_supervisor' do

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

  let(:chef_run) { runner.converge('fixtures::easybib_supervisor') }

  describe 'easybib_supervisor actions' do
    describe 'create' do
      before { stub_supervisor_with_one_valid_service }

      it 'enables a service' do
        expect(chef_run).to enable_supervisor_service('service1-some-app')
          .with(
          :command => 'servicecmd',
        )
        expect(chef_run).to start_supervisor_service('service1-some-app')
      end
    end
  end

  describe 'easybib_supervisor without file' do
    describe 'create' do
      before { stub_supervisor_does_not_exist }

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

def stub_supervisor_with_one_valid_service
  ::File.stub(:exist?).with(anything).and_call_original
  ::File.stub(:exist?).with('/some_file').and_return true

  ::File.stub(:read).with(anything).and_call_original
  ::File.stub(:read).with('/some_file').and_return '{"service1": {"command": "servicecmd"}}'
end
