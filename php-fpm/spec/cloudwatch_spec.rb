require 'chefspec'

describe 'php-fpm::cloudwatch' do
  let(:runner) { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node) { runner.node }

  before do
    node.set['opsworks']['stack']['name'] = 'Stack'
    node.set['opsworks']['stack']['name'] = 'Stack'
  end

  describe 'cloudwatch cron default disabled' do
    it 'does not create cronjob script' do
      expect(chef_run).to_not render_file("#{node['php-fpm']['prefix']}/bin/phpfpm-cloudwatch.sh")
    end

    it 'does not init cronjob' do
      expect(chef_run).to_not create_cron_d('phpfpm-cloudwatch')
    end
  end

  describe 'cloudwatch cron enabled' do
    before do
      node.set['php-fpm']['cloudwatch'] = true
    end

    it 'creates cronjob script' do
      expect(chef_run).to render_file("#{node['php-fpm']['prefix']}/bin/phpfpm-cloudwatch.sh")
        .with_content(
          include('dimensions StackId=stack,InstanceId=host_stack')
        )
    end

    it 'inits cronjob' do
      expect(chef_run).to create_cron_d('phpfpm-cloudwatch')
    end
  end
end
