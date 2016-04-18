require 'chefspec'
require 'set'

shared_examples_for 'puma nginx template' do
  let(:stack) { 'Stack Name' }
  let(:template_name) { "/etc/nginx/sites-enabled/#{app_config_shortname}.conf" }

  before do
    stub_command('rm -f /etc/nginx/sites-enabled/default').and_return(true)
  end

  describe 'nginx configuration template' do
    it 'writes virtualhost' do
      expect(chef_run).to create_template(template_name)
        .with(
          :path => template_name,
          :source => 'default-web-nginx.conf.erb'
        )

      template_resource = chef_run.template(template_name)
      expect(template_resource).to notify("execute[nginx_configtest_#{app_config_shortname}]")
        .to(:run)
        .immediately
    end

    it 'sets the correct root' do
      expect(chef_run).to render_file(template_name)
        .with_content(
          include('root /vagrant_cmbm/public/;')
        )
    end

    it 'sets the correct upstream' do
      expect(chef_run).to render_file(template_name)
        .with_content(
          include('proxy_pass        http://127.0.0.1:3000')
        )
    end

    it 'sets all mandatory X-Forward-* headers' do
      expect(chef_run).to render_file(template_name)
        .with_content(
          include('proxy_set_header  X-Real-IP         $remote_addr;')
        )
        .with_content(
          include('proxy_set_header  X-Forwarded-For   $proxy_add_x_forwarded_for;')
        )
        .with_content(
          include('proxy_set_header  X-Forwarded-Proto $scheme;')
        )
    end

    it 'configure access-logging' do
      expect(chef_run).to render_file(template_name)
        .with_content(
          include('access_log off;')
        )
    end
  end
end
