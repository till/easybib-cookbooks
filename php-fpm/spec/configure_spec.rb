require 'chefspec'

describe 'php-fpm::configure' do

  let(:runner) { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node) { runner.node }

  let(:etc_dir) { '/opt/easybib/etc' }
  let(:pool_dir) { "#{etc_dir}/php-fpm/pool.d" }

  it 'creates the pool configuration directory' do
    expect(chef_run).to create_directory(pool_dir)
  end

  it 'creates php-fpm.conf with an include directive' do
    expect(chef_run).to render_file("#{etc_dir}/php-fpm.conf")
      .with_content(
        include("include=#{pool_dir}/*.conf")
      )
  end

  describe 'pool configuration' do
    before do
      node.set['php-fpm']['pools']        = %w(app1 app2 app3)
      node.set['php-fpm']['max_children'] = 99
    end

    it 'creates three pool configurations' do
      node['php-fpm']['pools'].each do |pool_name|
        expect(chef_run).to render_file("#{pool_dir}/#{pool_name}.conf")
          .with_content(
            include("[#{pool_name}]")
          )
      end
    end

    it 'sets correct max_childrens' do
      node['php-fpm']['pools'].each do |pool_name|
        expect(chef_run).to render_file("#{pool_dir}/#{pool_name}.conf")
          .with_content(
            include('pm.max_children = 99')
          )
      end
    end

    it 'sets correct type' do
      node['php-fpm']['pools'].each do |pool_name|
        expect(chef_run).to render_file("#{pool_dir}/#{pool_name}.conf")
          .with_content(
            include('pm = dynamic')
          )
      end
    end

    describe 'update-alternatives' do
      before do
        node.set['php']['ppa']['package_prefix'] = 'php8.5'
      end

      it 'runs update-alternatives' do
        resource = chef_run.template('/opt/easybib/etc/php.ini')
        expect(resource).to notify('execute[update-alternatives]')
        expect(resource).to notify('execute[update-cli-alternatives]')
      end

      it 'sets the correct target on update-alternatives' do
        resource_fpm = chef_run.execute('update-alternatives')
        resource_cli = chef_run.execute('update-cli-alternatives')

        expect(resource_fpm.command).to include('--install')
        expect(resource_fpm.command).to include('/usr/sbin/php-fpm8.5')

        expect(resource_cli.command).to include('--set')
        expect(resource_cli.command).to include('/usr/bin/php8.5')
      end

      it 'finds update-alternatives for the correct version' do
        alternatives = []
        alternatives << '/usr/bin/update-alternatives'
        alternatives << '--install'
        alternatives << '/usr/sbin/php-fpm'
        alternatives << 'php-fpm'
        alternatives << '/usr/sbin/php-fpm8.5'
        alternatives << '0'

        resource = chef_run.execute('update-alternatives')
        expect(resource.command).to eq(alternatives.join(' '))

        expect(chef_run).not_to run_execute('update-alternatives')
        expect(chef_run).not_to run_execute('update-cli-alternatives')
      end
    end

  end

end
