require 'chefspec'

describe 'easybib_vagrant' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../")
    ]
  end

  let(:runner)   { ChefSpec::Runner.new(:cookbook_path => cookbook_paths) }
  let(:chef_run) { runner.converge('easybib_vagrant::default') }
  let(:node)     { runner.node }

  describe 'default' do
    it 'creates directories for the user' do
      expect(chef_run).to create_directory('/root/.ssh')
      expect(chef_run).to create_directory('/root/.config/easybib')
      expect(chef_run).to create_directory('/root/.vagrant.d')

      expect(chef_run).to include_recipe('easybib_vagrant::cookbooks')
      expect(chef_run).to include_recipe('easybib_vagrant::configure')
    end
  end

  describe 'default/opsworks' do
    before do
      node.set['opsworks'] = {
        'super' => 'cool'
      }
      node.set['easybib_vagrant']['environment'] = {
        'user' => 'vagrantci',
        'group' => 'vagrantci',
        'home' => '/home/vagrantci'
      }
    end

    it 'creates directories in /home/vagrantci/' do
      expect(chef_run).to create_directory('/home/vagrantci/.vagrant.d')
    end
  end
end
