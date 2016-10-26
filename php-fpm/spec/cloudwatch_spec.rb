require 'chefspec'

describe 'php-fpm::cloudwatch' do
  let(:runner) { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node) { runner.node }
  let(:cronscript_name) { "#{node['php-fpm']['prefix']}/bin/phpfpm-cloudwatch.sh" }

  before do
    node.override['opsworks']['stack']['name'] = 'Stack'
    node.override['opsworks']['instance']['hostname'] = 'host'
  end

  describe 'cloudwatch enabled' do
    before do
      node.override['php-fpm']['cloudwatch'] = true
    end

    it 'creates cronjob script' do
      expect(chef_run).to render_file(cronscript_name)
        .with_content(
          include('dimensions StackId=stack,InstanceId=host_stack')
        )
    end

    it 'notifies cron_d' do
      cronscript_resource = chef_run.template(cronscript_name)
      expect(cronscript_resource).to notify('cron_d[phpfpm-cloudwatch]')
        .to(:create)
        .immediately
    end
  end

  describe 'cloudwatch disabled' do
    before do
      node.override['php-fpm']['cloudwatch'] = false
    end

    it 'does not create cronjob script' do
      expect(chef_run).to_not render_file(cronscript_name)
    end

    # this will not work in the state it's in
    # https://github.com/sethvargo/chefspec/pull/547#issuecomment-68649062
    # I do not fully understand but I am vaguely understanding that chefspec
    # always assumes notification
    # it 'does not notify cron_d' do
    #   cronscript_resource = chef_run.template(cronscript_name)
    #   expect(cronscript_resource).to_not notify('cron_d[phpfpm-cloudwatch]')
    #     .to(:create)
    #     .immediately
    # end
  end
end
