actions :install, :setup, :compile

def initialize(*args)
  super
  @action  = :install
  @prefix  = node["php-fpm"]["prefix"]
end

attribute :prefix, :kind_of => String
attribute :package, :kind_of => String, :name_attribute => true
attribute :version, :kind_of => String, :default => nil
attribute :config,  :kind_of => Hash
attribute :source_dir, :kind_of => String
attribute :cflags, :kind_of => String
attribute :config_directives, :kind_of => Hash, :default => {}
attribute :zend_extensions, :kind_of => Array, :default => []
