require_relative 'spec_helper'

describe 'easybib_nginx htpasswd' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../"),
      File.expand_path("#{File.dirname(__FILE__)}/")
    ]
  end

  let(:runner) do
    ChefSpec::Runner.new(
      :cookbook_path => cookbook_paths,
      :step_into => ['easybib_nginx']
    )
  end

  let(:chef_run) { runner.converge('fixtures::easybib_nginx_htpasswd') }
  let(:node)     { runner.node }

  let(:htpasswd_file) { '/etc/nginx/has_htpasswd_string.htpasswd' }
  let(:nginx_config_filename) { '/etc/nginx/sites-enabled/has_htpasswd.conf' }
  let(:nginx_config_generated) { '/etc/nginx/sites-enabled/has_htpasswd_string.conf' }

  describe 'htpasswd file is used if no : in name' do
    before do
      ::File.stub(:exist?).with(anything).and_call_original
      ::File.stub(:exist?).with('/some_path').and_return true
      ::File.stub(:exist?).with(htpasswd_file).and_return true
    end

    it 'include filename to htpasswd if specified' do
      expect(chef_run).to render_file(nginx_config_filename)
        .with_content(
          include('auth_basic_user_file  /some_path;')
        )
    end
    it 'generates htpasswd if user:pass specified' do
      expect(chef_run).to render_file(htpasswd_file)
        .with_content(
          include('user:usGhvISzyaLuU')
        )
      expect(chef_run).to render_file(nginx_config_generated)
        .with_content(
        include('auth_basic_user_file  /etc/nginx/has_htpasswd_string.htpasswd;')
      )
    end
  end
end
