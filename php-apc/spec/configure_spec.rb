require 'chefspec'

describe 'php-apc::configure' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge('php-apc::configure') }
  it "creates apc.ini" do
    expect(chef_run).to create_file("/opt/easybib/etc/php/apc.ini")
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

    chef_run.converge 'php-apc::configure'

    conf = "extension=apc.so\n"
    conf << "apc.ttl=0\n"
    conf << "apc.mmap_file_mask=/dev/zero\n"
    conf << "apc.shm_size=70M\n"
    conf << "\n"
    conf << "apc.stat=0\n"
    conf << "apc.slam_defense=1\n"
    conf << "apc.max_file_size=2M\n"
    expect(chef_run).to create_file_with_content "/opt/easybib/etc/php/apc.ini", conf
  end
end
