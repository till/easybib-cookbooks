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
      node.set['php-fpm']['pools'] = %w('app1', 'app2', 'app3')
    end

    it 'creates three pool configurations' do
      node['php-fpm']['pools'].each do |pool_name|
        expect(chef_run).to render_file("#{pool_dir}/#{pool_name}.conf")
          .with_content(
            include("[#{pool_name}]")
          )
      end
    end
  end

end
