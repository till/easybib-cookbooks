actions :install, :uninstall, :upgrade, :install_if_missing

default_action :install

attribute :package, :kind_of => String, :name_attribute => true
attribute :channel, :kind_of => String, :default => 'pear.php.net'
attribute :version, :kind_of => String, :default => nil
attribute :force, :equal_to => [true, false], :default => false
