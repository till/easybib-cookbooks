require 'chefspec'

describe "tsung::default" do

  let(:runner)   { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge("tsung::default") }
  let(:node)     { runner.node }

  let(:deb_file) { "tsung_#{node["tsung"]["version"]}-#{node["tsung"]["pkgrev"]}_all.deb" }
  let(:log_dir) { "/home/#{node["tsung"]["user"]}/.tsung/log" }

  it "sets up tsung and configures nginx" do
    expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/#{deb_file}")
    expect(chef_run).to install_package(deb_file)
    expect(chef_run).to create_directory(log_dir)
    expect(chef_run).to render_file("/etc/nginx/sites-available/tsung")
      .with_content(
        include("access_log off;")
      )
  end

end
