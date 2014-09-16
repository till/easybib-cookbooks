require 'chefspec'

describe 'nginx-app::configure' do

  let(:runner) do
    ChefSpec::Runner.new(
      :step_into => ["nginx_app_config"],
      :version => 12.04
    )
  end
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  let(:vhost) { "/etc/nginx/sites-enabled/easybib.com.conf" }
  let(:access_log) { "/some/drive/access.log" }
  let(:php_user) { "some_user_account" }
  let(:stack) { "Stack Name" }

  describe "deployment" do
    before do
      stub_command('rm -f /etc/nginx/sites-enabled/default').and_return(true)

      node.set["deploy"] = {}

      node.set["easybib"]["cluster_name"] = stack

      node.set["opsworks"]["instance"]["layers"] = ["nginxphpapp"]
      node.set["opsworks"]["stack"]["name"] = stack

      node.set["docroot"] = "public"
    end

    it "includes necessary recipes" do
      expect(chef_run).to include_recipe "nginx-app::server"
    end

    describe "virtualhost" do
      before do
        node.set["deploy"]["easybib"] = {
          "deploy_to" => "/srv/www/easybib"
        }
        node.set["nginx-app"]["access_log"] = access_log
        node.set["php-fpm"]["user"] = php_user
      end

      it "writes virtualhost for app 'easybib'" do
        expect(chef_run).to create_template("render vhost: easybib")
          .with(:source => "easybib.com.conf.erb")

        template_resource = chef_run.template("render vhost: easybib")
        expect(template_resource).to notify('service[nginx]')
          .to(:restart)
          .delayed
      end

      it "sets the correct upstream" do
        expect(chef_run).to render_file(vhost)
          .with_content(
            "unix:/var/run/php-fpm/#{php_user}"
          )
      end

      it "sets the correct BIB_ENV" do
        expect(chef_run).to render_file(vhost)
          .with_content(
            include("fastcgi_param BIB_ENV \"#{stack}\";")
          )
      end

      it "sets the correct SCRIPT_FILENAME" do
        expect(chef_run).to render_file(vhost)
          .with_content(
            include('fastcgi_param SCRIPT_FILENAME /srv/www/easybib/current/public/index.php;')
          )
      end

      it "sets the correct access_log" do
        expect(chef_run).to render_file(vhost)
          .with_content(
            include("access_log #{access_log};")
          )
      end

      describe "infolit" do
        before do
          node.set["deploy"]["infolit"] = {
            "deploy_to" => "/srv/www/infolit"
          }
        end

        it "creates the virtualhost from the correct erb" do
          expect(chef_run).to create_template("render vhost: infolit")
            .with(
              :name => vhost,
              :source => "infolit.conf.erb"
            )
        end
      end
    end
  end
end
