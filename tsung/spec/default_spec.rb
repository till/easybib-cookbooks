require 'chefspec'

describe "tsung::default" do

  let(:runner)   { ChefSpec::Runner.new(:version => 10.04) }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  let(:deb_file) { "tsung_#{node["tsung"]["version"]}-#{node["tsung"]["pkgrev"]}_all.deb" }
  let(:log_dir) { "/home/#{node["tsung"]["user"]}/.tsung/log" }

  describe "lucid" do
    it "installs tsung from a downloaded .deb" do
      expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/#{deb_file}")
      expect(chef_run).to install_package(deb_file)
    end

    it "configures nginx" do
      expect(chef_run).to create_directory(log_dir)
      expect(chef_run).to render_file("/etc/nginx/sites-available/tsung")
        .with_content(
          include("access_log off;")
        )
    end
  end

  describe "precise" do
    before do
      node.set["lsb"]["codename"] = "precise"
    end

    it "installs tsung from regular repositories" do
      expect(chef_run).to install_package("tsung")
    end
  end
end
