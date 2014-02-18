require 'chefspec'

describe 'bash::bashrc' do

  let (:chef_run) do
    ChefSpec::Runner.new do |node|
      # fake opsworks
      node.default["opsworks"] = {}
      node.default.opsworks["stack"] = {}
      node.default.opsworks.stack["name"] = "chef-spec-run"
      node.default.opsworks["instance"] = {}
      node.default.opsworks.instance["layers"] = []
    end.converge(described_recipe)
  end

  it "creates a directory and a file" do
    expect(chef_run).to render_file("/etc/bash.bashrc")
    expect(chef_run).to create_directory("/etc/bashrc.d")
  end

end
