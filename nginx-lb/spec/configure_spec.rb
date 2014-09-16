require 'chefspec'
require_relative 'support/matchers'

describe 'nginx-lb::configure' do

  let(:runner) do
    ChefSpec::Runner.new(:step_into => ["nginx_app_config"]) do |node|
      node.automatic["cpu"]["total"] = 20
    end
  end

  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  let(:nginx_conf) { "/etc/nginx/nginx.conf" }
  let(:access_log) { "/some/drive/access.log" }
  let(:php_user) { "some_user_account" }
  let(:stack) { "Stack Name" }

  describe "nginx.conf generation" do
    before do
      stub_command('rm -f /etc/nginx/sites-enabled/default').and_return(true)
    end

    it "includes necessary recipes" do
      expect(chef_run).to include_recipe "nginx-lb::service"
    end

    describe "virtualhost" do
      before do
        node.set["nginx-lb"]["user"] = "johndoe"
      end

      it "writes the configuration" do
        expect(chef_run).to create_template(nginx_conf)
          .with(
            :cookbook => "nginx-lb",
            :source => "nginx.conf.erb"
          )
      end

      it "claims all but one cpu" do
        expect(chef_run).to render_file(nginx_conf)
          .with_content(
            include("worker_processes 19;")
          )
      end

      it "configures nginx to run with the correct user" do
        expect(chef_run).to render_file(nginx_conf)
          .with_content(
            include("user johndoe;")
          )
      end

      it "notifies service[nginx] to stop" do
        resource = chef_run.nginx_app_config("nginx-lb: nginx.conf")
        expect(resource).to notify('service[nginx]')
          .to(:stop)
      end
    end
  end
end
