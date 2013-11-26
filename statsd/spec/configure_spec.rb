require 'chefspec'

describe 'statsd::configure' do

  let (:chef_run) do
    ChefSpec::Runner.new do |node|
      # fake opsworks
      node.default["opsworks"] = {}
      node.default.opsworks["stack"] = {}
      node.default.opsworks.stack["name"] = "chef spec run"
    end.converge(described_recipe)
  end

  it "creates /etc/statsd/config.js" do
    expect(chef_run).to render_file("/etc/statsd/config.js")
  end

  it "it contains the correct settings" do

    # before you think twice - this is javascript, not JSON
    conf  = "{\n"
    conf << "  port: 8125,\n"
    conf << "  mgmt_address: '127.0.0.1',\n"
    conf << "  backends: ['statsd-librato-backend'],\n"
    conf << "  librato: {\n"
    conf << "    email: 'foo@example.org',\n"
    conf << "    token: '123',\n"
    conf << "    source: 'chef-spec-run',\n"
    conf << "    batchSize: 200\n"
    conf << "  }\n"
    conf << "}\n"

    expect(chef_run).to render_file("/etc/statsd/config.js").with_content(conf)
  end
end
