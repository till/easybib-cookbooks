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
    before do
      Dir.stub(:home) { '/root' }
    end

    it 'creates configuration files for the user' do

      expect(chef_run).not_to render_file('/root/.ssh/config')
      expect(chef_run).to render_file('/root/.config/easybib/vagrantdefault.yml')
      expect(chef_run).to render_file('/root/.vagrant.d/Vagrantfile')

      expect(chef_run).to create_directory('/root/.ssh')
      expect(chef_run).to create_directory('/root/.config/easybib')
      expect(chef_run).to create_directory('/root/.vagrant.d')
    end
  end

  describe 'default/opsworks' do
    before do
      Dir.stub(:home) { '/home/vagrantci' }

      node.set['opsworks'] = {
        'super' => 'cool'
      }
      node.set['easybib_vagrant']['environment'] = {
        'user' => 'vagrantci',
        'group' => 'vagrantci'
      }
    end

    it 'renders the /home/vagrantci/.ssh/config' do
      expect(chef_run).to render_file('/home/vagrantci/.ssh/config')
    end
  end
end
