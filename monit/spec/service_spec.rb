require 'chefspec'

describe 'monit::service' do

  let(:runner) do
    ChefSpec::SoloRunner.new(
      :log_level => :error
    )
  end
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }
  let(:notification) { '/etc/monit/conf.d/mailnotify.monitrc' }

  describe 'pre-refactoring madness' do
    it 'defines a service' do
      service = chef_run.service('monit')
      expect(service).to do_nothing
    end

    it 'includes other recipes' do
      expect(chef_run).to include_recipe('monit')
      expect(chef_run).to include_recipe('monit::mailnotify')
      expect(chef_run).to include_recipe('monit::systemcheck')
    end

    it 'creates a notification configuration from a file' do
      expect(chef_run).to render_file(notification)

      file = chef_run.cookbook_file(notification)
      expect(file).to notify('service[monit]')
    end
  end
end
