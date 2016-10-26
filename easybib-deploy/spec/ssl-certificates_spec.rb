require 'chefspec'

describe 'easybib-deploy::ssl-certificates' do

  let(:runner) do
    ChefSpec::Runner.new(
      :log_level => :fatal,
      :step_into => %w(nginx_app_config easybib_nginx easybib_sslcertificate)
    )
  end
  let(:chef_run)   { runner.converge(described_recipe) }
  let(:node)       { runner.node }

  let(:ssl_dir)    { '/tmp/ssl/' }
  let(:ssl_role)   { 'ssl' }
  let(:dummy_key)  { '-----BEGIN PRIVATE KEY-----[...]-----END PRIVATE KEY-----' }
  let(:dummy_cert) { '-----BEGIN CERTIFICATE-----[...]-----END CERTIFICATE-----' }

  before do
    node.override['ssl-deploy']['ssl-role']  = ssl_role
    node.override['ssl-deploy']['directory'] = ssl_dir
    node.override['opsworks']['instance']['layers'] = ssl_role # for allow_deploy
    node.override['deploy'][ssl_role]['ssl_certificate']     = dummy_cert
    node.override['deploy'][ssl_role]['ssl_certificate_key'] = dummy_key
    node.override['deploy'][ssl_role]['ssl_certificate_ca']  = dummy_cert
  end

  describe 'everything set should create all certs completely' do
    it 'does create ssl directoy' do
      expect(chef_run).to create_directory(ssl_dir)
    end

    it 'does create certificate' do
      expect(chef_run).to create_template(ssl_dir + '/cert.pem').with(
        :user => 'root',
        :mode => '0640'
      )
      expect(chef_run).to render_file(ssl_dir + '/cert.pem').with_content(dummy_cert)
    end
    it 'does create certificate key' do
      expect(chef_run).to create_template(ssl_dir + '/cert.key').with(
        :user => 'root',
        :mode => '0640'
      )
      expect(chef_run).to render_file(ssl_dir + '/cert.key').with_content(dummy_key)
    end
    it 'does create combined certificate' do
      expect(chef_run).to create_template(ssl_dir + '/cert.combined.pem').with(
        :user => 'root',
        :mode => '0640'
      )
      expect(chef_run).to render_file(ssl_dir + '/cert.combined.pem').with_content(
        [dummy_cert, dummy_key, dummy_cert].join("\n")
      )
    end
  end

  describe 'another app is being deployed' do
    before do
      node.override['ssl-deploy']['ssl-role']  = 'whatever'
    end

    it 'does not attempt to create ssl directoy' do
      expect(chef_run).not_to create_directory(ssl_dir)
    end
    it 'does not attempt to create ssl certificate' do
      expect(chef_run).not_to create_template(ssl_dir + '/cert.pem')
    end
  end

  describe 'ssl app without certificate key' do
    before do
      node.override['deploy'][ssl_role]['ssl_certificate_key'] = ''
    end

    it 'does not attempt to create ssl directoy' do
      expect(chef_run).not_to create_directory(ssl_dir)
    end

  end

  describe 'ssl certificates should work without intermediate ca set' do
    before do
      node.override['deploy'][ssl_role]['ssl_certificate_ca'] = nil
    end

    it 'does create combined certificate without intermediate ca' do
      expect(chef_run).to create_template(ssl_dir + '/cert.combined.pem').with(
        :user => 'root',
        :mode => '0640'
      )
      expect(chef_run).to render_file(ssl_dir + '/cert.combined.pem').with_content(
        [dummy_cert, dummy_key, ''].join("\n")
      )
    end
  end
end
