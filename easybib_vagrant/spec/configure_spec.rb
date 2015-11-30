require 'chefspec'

describe 'easybib_vagrant' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../")
    ]
  end

  let(:runner)   { ChefSpec::Runner.new(:cookbook_path => cookbook_paths) }
  let(:chef_run) { runner.converge('easybib_vagrant::configure') }
  let(:node)     { runner.node }

  describe 'configure' do
    it 'creates configuration files for root' do
      expect(chef_run).not_to render_file('/root/.ssh/config')
      expect(chef_run).to render_file('/root/.config/easybib/vagrantdefault.yml').with_content(
        include('/root/easybib-cookbooks')
      )
      expect(chef_run).to render_file('/root/.vagrant.d/Vagrantfile')
    end
  end

  describe 'configure/opsworks' do
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

    it 'renders the /home/vagrantci/.ssh/config' do
      expect(chef_run).to render_file('/home/vagrantci/.ssh/config')
    end

    it 'renders the correct cookbook path in vagrantdefault.yml' do
      expect(chef_run).to render_file('/home/vagrantci/.config/easybib/vagrantdefault.yml').with_content(
        include('cookbook_path: /home/vagrantci/easybib-cookbooks')
      )
    end
  end
end
