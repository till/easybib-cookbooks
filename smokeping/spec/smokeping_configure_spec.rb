require_relative 'spec_helper'

describe 'smokeping_configure' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../")
    ]
  end

  let(:runner) do
    ChefSpec::Runner.new(
      :cookbook_path => cookbook_paths
    )
  end

  let(:node) { runner.node }

  let(:chef_run) { runner.converge('smokeping::configure') }

  describe 'smokeping pathnames configuration' do
    it 'renders pathnames' do
      expect(chef_run).to render_file('/etc/smokeping/config.d/pathnames')
        .with_content(
          include('imgcache = /var/cache/smokeping/images')
      )
        .with_content(
          include('sendmail = /usr/sbin/sendmail')
      )
    end
    it 'renders probes' do
      expect(chef_run).to render_file('/etc/smokeping/config.d/Probes')
        .with_content(
          include('binary = /usr/bin/fping')
        )
    end
    it 'renders targets' do
      expect(chef_run).to render_file('/etc/smokeping/config.d/Targets')
        .with_content(
          include('*** Targets ***')
        )
    end
    it 'does not include tcpping or hccping' do
      expect(chef_run).not_to include_recipe('smokeping::tcpping')
      expect(chef_run).not_to include_recipe('smokeping::hping')
    end
  end

  describe 'smokeping installation with probes set in config' do
    before do
      node.set['smokeping']['probes']['TCPPing'] = { 'binary' => '/whatever' }
      node.set['smokeping']['probes']['HPing']   = { 'binary' => '/whatever_else' }
    end
    it 'does include hping and tcpping recipes' do
      expect(chef_run).to include_recipe('smokeping::tcpping')
      expect(chef_run).to include_recipe('smokeping::hping')
    end
  end

  describe 'smokeping installation with targets set in config' do
    before do
      node.set['smokeping']['targets']['foogroup'] = [
        {
          'host' => 'foo.com',
          'menu' => 'foo',
          'probe' => 'fping',
          'title' => 'footitle'
        }
      ]
    end
    it 'renders target set in config' do
      expect(chef_run).to render_file('/etc/smokeping/config.d/Targets')
        .with_content(
          include('host = foo.com')
        )
    end
  end
end
