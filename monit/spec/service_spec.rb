require 'chefspec'

describe 'monit::service' do

  let(:runner) do
    ChefSpec::Runner.new(
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

  describe 'Amazon SES integration' do
    before do
      node.set['monit'] = {
        :mailsender => 'root@localhost',
        :mailhost => 'localhost',
        :mailpass => 'changeme',
        :mailport => 25,
        :mailuser => 'account',
        :notification_recipients => ['root@localhost']
      }
    end

    it 'does not create the standard configuration' do
      expect(chef_run).not_to render_file(notification)
    end

    it 'creates a configuration from a template' do
      expect(chef_run).to create_template(notification)

      template = chef_run.template(notification)
      expect(template).to notify('service[monit]')
    end
  end
end
