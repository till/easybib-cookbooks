require_relative 'spec_helper'

describe 'stack-wpt::role-vagrant' do
  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../")
    ]
  end

  let(:runner)    { ChefSpec::Runner.new(:cookbook_path => cookbook_paths) }
  let(:node)      { runner.node }
  let(:chef_run)  { runner.converge(described_recipe) }

  let(:php_version) { '7.0' }

  before do
    node.override['vagrant']['applications'] = {}
  end

  describe 'nodejs/npm setup' do
    it 'installs node and npm' do
      expect(chef_run).to include_recipe('nodejs::nodejs_from_binary')
      expect(chef_run).to include_recipe('nodejs::npm_from_latest')
    end

    it 'installs a specific npm version' do
      expect(chef_run).to run_execute('Install npm')
    end
  end

  describe 'PHP setup' do
    it 'installs the correct PHP version by default' do
      %W(
        php#{php_version}-fpm
        php#{php_version}-cli
        php#{php_version}-mbstring
        php#{php_version}-mysql
        php#{php_version}-curl
        php#{php_version}-bcmath
        php#{php_version}-dom
        php-memcached
      ).each do |php_deb_package|
        expect(chef_run).to install_package(php_deb_package)
      end
    end
  end

  describe 'vagrant setup' do
    it 'includes all role recipes' do
      %w(
        stack-wpt::role-languagetool
        stack-wpt::role-libreoffice
        stack-wpt::role-nodejs
      ).each do |role_recipe|
        expect(chef_run).to include_recipe(role_recipe)
      end
    end
  end
end
