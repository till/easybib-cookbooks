Vagrant::Config.run do |config|
  config.vm.box = "lucid-nfs_0.1_4.1.0"

  config.vm.network :hostonly, "33.33.33.124"

  config.vbguest.auto_update = true

    config.vm.customize [
        "modifyvm", :id,
        "--name", "Vagrant Cookbook Testbox",
        "--memory", "256"
    ]

  config.vm.provision :shell, :path => "./update-mirrors.sh"

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "./../"
    chef.add_recipe "php-fpm"
    chef.add_recipe "php-xdebug"

    chef.log_level = :debug
  end
end
