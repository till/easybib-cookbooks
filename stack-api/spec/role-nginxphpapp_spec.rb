require_relative 'spec_helper'

describe 'stack-api::role-nginxphpapp' do
  let(:runner)       { ChefSpec::Runner.new(:step_into => ['php-fpm']).converge('ies::role-phpapp') }
  let(:chef_run)     { runner.converge(described_recipe) }
  let(:node)         { runner.node }
  let(:php_version)  { '5.6' }
  let(:php_deps)     do
    %W(
      php#{php_version}-apcu
      php#{php_version}-bcmath
      php#{php_version}-cli
      php#{php_version}-ctype
      php#{php_version}-curl
      php#{php_version}-dom
      php#{php_version}-fileinfo
      php#{php_version}-fpm
      php#{php_version}-iconv
      php#{php_version}-intl
      php#{php_version}-json
      php#{php_version}-mbstring
      php#{php_version}-memcache
      php#{php_version}-pdo-mysql
      php#{php_version}-pdo-pgsql
      php#{php_version}-phar
      php#{php_version}-simplexml
      php#{php_version}-soap
      php#{php_version}-sockets
      php#{php_version}-tidy
      php#{php_version}-tokenizer
      php#{php_version}-xml
      php#{php_version}-xmlreader
      php#{php_version}-xmlwriter
      php#{php_version}-opcache
      php#{php_version}-zip
    ).join(',')
  end

  before do
    node.override['opsworks']['stack']['name'] = 'Stack'
    node.override['opsworks']['instance']['layers'] = ['silex']
    node.override['opsworks']['instance']['hostname'] = 'host'
    node.override['opsworks']['instance']['ip'] = '127.0.0.1'
    node.override['deploy']['sitescraper'] = {
      :deploy_to => '/srv/www/silex',
      :document_root => 'public'
    }
    node.override['php-fpm']['packages'] = php_deps
  end

  it 'pulls in ies::role-phpapp' do
    expect(chef_run).to include_recipe('ies::role-phpapp')
  end

  it 'deploys silex' do
    expect(chef_run).to include_recipe('stack-api::deploy-silex')
  end

  it 'installs all php-module deps' do
    php_deps.split(',').each do |dep|
      expect(chef_run).to install_package(dep)
    end
  end
end
