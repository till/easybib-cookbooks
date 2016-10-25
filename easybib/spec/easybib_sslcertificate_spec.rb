require_relative 'spec_helper'

describe 'easybib_sslcertificate' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../"),
      File.expand_path("#{File.dirname(__FILE__)}/")
    ]
  end

  let(:runner) do
    ChefSpec::Runner.new(
      :cookbook_path => cookbook_paths,
      :step_into => ['easybib_sslcertificate']
    )
  end

  let(:node) { runner.node }

  let(:chef_run) { runner.converge('fixtures::easybib_sslcertificate') }

  let(:ssl_dir) { '/etc/nginx/ssl' }

  let(:ssl_cert) { '-----BEGIN-CERT' }

  let(:ssl_key) { '-----BEGIN-KEY' }

  describe 'OpsWorks: SSL app' do
    before do
      fake_deploy                        = {}
      fake_deploy['ssl_certificate']     = ssl_cert
      fake_deploy['ssl_certificate_key'] = ssl_key

      node.set['fake_deploy'] = fake_deploy
    end

    it 'invokes the provider' do
      expect(chef_run).to create_easybib_sslcertificate('something')
    end

    it 'creates the ssl_dir' do
      expect(chef_run).to create_directory(ssl_dir)
    end

    it 'creates the cert and key files' do
      expect(chef_run).to create_template("#{ssl_dir}/cert.key")

      expect(chef_run).to render_file("#{ssl_dir}/cert.key")
        .with_content(ssl_key)

      expect(chef_run).to create_template("#{ssl_dir}/cert.pem")

      expect(chef_run).to render_file("#{ssl_dir}/cert.pem")
        .with_content(ssl_cert)
    end

    it 'creates the combined file for haproxy' do
      expect(chef_run).to render_file("#{ssl_dir}/cert.combined.pem")
        .with_content("#{ssl_cert}\n#{ssl_key}\n")
    end
  end

  describe 'SSL from files generated' do
    before do
      stub_ssl_files

      fake_deploy                        = {}
      fake_deploy['ssl_certificate']     = '/tmp/example.org.pem'
      fake_deploy['ssl_certificate_key'] = '/tmp/example.org.key'

      node.set['fake_deploy'] = fake_deploy
    end

    it 'creates the files with the correct content' do
      expect(chef_run).to render_file("#{ssl_dir}/cert.key")
        .with_content('-----BEGIN-example.key')

      expect(chef_run).to render_file("#{ssl_dir}/cert.pem")
        .with_content('-----BEGIN-example.pem')

      expect(chef_run).to render_file("#{ssl_dir}/cert.combined.pem")
        .with_content("-----BEGIN-example.pem\n-----BEGIN-example.key\n")
    end
  end
end

def stub_ssl_files
  ::File.stub(:read).with(anything).and_call_original
  ::File.stub(:read).with('/tmp/example.org.key').and_return('-----BEGIN-example.key')
  ::File.stub(:read).with('/tmp/example.org.pem').and_return('-----BEGIN-example.pem')
end
