require 'chefspec'

describe 'nginx-app::configure' do

  let(:runner) do
    ChefSpec::Runner.new(
      :step_into => ['nginx_app_config']
    )
  end
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  let(:vhost) { '/etc/nginx/sites-enabled/easybib.com.conf' }
  let(:stack) { 'Stack Name' }
  let(:template_name) { 'render vhost: infolit' }
  let(:conf_name) { 'infolit.conf.erb' }

  describe 'infolit deployment' do
    before do

      stub_command('rm -f /etc/nginx/sites-enabled/default').and_return(true)

      node.set['easybib']['cluster_name'] = stack

      node.set['opsworks']['instance']['layers'] = ['nginxphpapp']
      node.set['opsworks']['stack']['name'] = stack

      #node.set['docroot'] = 'public'

      node.set['deploy']['infolit'] = {
        'deploy_to' => '/srv/www/infolit',
        'document_root' => 'www'
      }

      node.set['infolit']['domain'] = 'infolit.tld'
    end

    it 'creates the virtualhost from the correct erb' do
      expect(chef_run).to create_template(template_name)
        .with(
          :path => vhost,
          :source => conf_name
        )
    end

    it 'sets the correct handlers for / and /search/ through the php-fpm partial' do
      expect(chef_run).to render_file(vhost)
        .with_content(
          include('location /search/ {')
        )
        .with_content(
          include('location / {')
        )
        .with_content(
          include('fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;')
        )
        .with_content(
          include('fastcgi_index search.php;')
        )
        .with_content(
          include('fastcgi_index index.php;')
        )
    end
  end
end
