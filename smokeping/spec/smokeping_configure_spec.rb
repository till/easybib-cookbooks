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
          include("binary = /usr/bin/fping")
        )
    end
    it 'renders targets' do
      expect(chef_run).to render_file('/etc/smokeping/config.d/Targets')
        .with_content(
          include('*** Targets ***')
        )
    end
  end
end