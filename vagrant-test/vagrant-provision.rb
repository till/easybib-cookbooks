require_relative 'vagrant-test-library'
vagrant_test_config = get_json(File.dirname(__FILE__) + '/setup.json')

Vagrant.configure('2') do |config|
  vagrant_config = Bib::Vagrant::Config.new.get

  config.vm.box = vagrant_test_config['box_file']
  config.vm.box_version = vagrant_test_config['box_version']
  config.vm.network 'private_network', ip: vagrant_test_config['box_ip']

  config.vm.provider 'virtualbox' do |vb|
    vb.gui = vagrant_config['gui']
  end

  config.vm.provision :shell, :inline => "sudo apt-spy2 fix --launchpad --country=#{get_country} --commit"
  config.vm.provision :shell, :inline => 'sudo apt-get update -y'

  chef_json = ENV.fetch('chef_json')

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = './../../'
    chef.json = get_json(chef_json) unless chef_json.empty?

    ENV.fetch('recipe_runlist').split(',').each do |recipe|
      chef.add_recipe(recipe)
    end

    chef.log_level = vagrant_config['chef_log_level']
  end
end
