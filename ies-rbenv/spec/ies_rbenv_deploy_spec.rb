require_relative 'spec_helper'

describe 'ies_rbenv_deploy' do
  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../"),
      File.expand_path("#{File.dirname(__FILE__)}/")
    ]
  end

  let(:runner) do
    ChefSpec::SoloRunner.new(
      :cookbook_path => cookbook_paths,
      :step_into => ['ies_rbenv_deploy']
    )
  end

  let(:chef_run) { runner.converge('fixtures::rbenv_deploy') }
  let(:node)     { runner.node }

  it 'installs ruby via ies-rbenv' do
    expect(chef_run).to install_ies_rbenv_deploy('deploy ruby')
  end
end
