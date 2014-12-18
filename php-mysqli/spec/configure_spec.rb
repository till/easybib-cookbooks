require 'chefspec'

describe 'php-mysqli::configure' do
  let(:chef_run) { ChefSpec::Runner.new.converge('php-mysqli::configure') }

  it 'creates mysqli-settings.ini which contains the correct settings' do

    chef_run = ChefSpec::Runner.new.converge('php-mysqli::configure')

    conf = "mysqli.reconnect = 1\n"
    expect(chef_run).to render_file('/opt/easybib/etc/php/mysqli-settings.ini').with_content(conf)
  end
end
