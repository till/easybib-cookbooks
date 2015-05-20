require 'chefspec'

describe 'easybib_vagrant' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../")
    ]
  end

  let(:runner)   { ChefSpec::Runner.new(:cookbook_path => cookbook_paths) }
  let(:chef_run) { runner.converge('easybib_vagrant::cookbooks') }
  let(:node)     { runner.node }

  describe 'cookbooks' do
    before do
      node.set['easybib_vagrant']['plugin_config']['bib-vagrant']['cookbook_path'] = '/tmp/foo'
      node.set['easybib_vagrant']['environment']['user'] = 'vagrantci'
    end

    it 'syncs the cookbooks to /tmp/foo' do
      expect(chef_run).to sync_git('/tmp/foo').with(:user => 'vagrantci')
    end
  end
end
