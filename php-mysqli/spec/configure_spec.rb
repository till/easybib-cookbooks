require 'chefspec'

describe 'php-mysqli::configure' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge('php-mysqli::configure') }
  it "creates mysqli-settings.ini" do
    expect(chef_run).to create_file("/opt/easybib/etc/php/mysqli-settings.ini")
  end
  it "it contains production settings" do

    chef_run = ChefSpec::ChefRunner.new do |node|
      # fake opsworks
      node.default["opsworks"] = {}
      node.default.opsworks["stack"] = {}
      node.default.opsworks.stack["name"] = "chef-spec-run"
      node.default.opsworks["instance"] = {}
      node.default.opsworks.instance["layers"] = []
    end

    chef_run.converge 'php-mysqli::configure'

    conf = "mysqli.reconnect = 1\n"
    expect(chef_run).to create_file_with_content "/opt/easybib/etc/php/mysqli-settings.ini", conf
  end
end
