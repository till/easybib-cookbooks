require 'chefspec'

describe 'statsd::configure' do

  let(:stack_name) { 'chef spec run' }

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      # fake opsworks
      node.default['opsworks'] = {}
      node.default.opsworks['stack'] = {}
      node.default.opsworks.stack['name'] = stack_name
    end.converge(described_recipe)
  end

  let(:config) { '/etc/statsd/localConfig.js' }

  it 'creates the config' do
    expect(chef_run).to render_file(config)
  end

  it 'it contains the correct settings' do
    # before you think twice - this is javascript, not JSON
    conf  = "{\n"
    conf << "  port: 8125,\n"
    conf << "  mgmt_address: '127.0.0.1',\n"
    conf << "  backends: ['statsd-librato-backend'],\n"
    conf << "  deleteIdleStats: true,\n"
    conf << "  librato: {\n"
    conf << "    email: 'foo@example.org',\n"
    conf << "    token: '123',\n"
    conf << "    source: '#{stack_name.gsub!(' ', '-')}',\n"
    conf << "    batchSize: 200\n"
    conf << "  },\n"
    conf << "  log: {\n"
    conf << "    backend: 'syslog'\n"
    conf << "  }\n"
    conf << "}\n"

    expect(chef_run).to render_file(config).with_content(conf)
  end
end
