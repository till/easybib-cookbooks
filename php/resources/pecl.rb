actions :install, :setup, :compile

def initialize(*args)
  super
  @action  = :install
  @version = ""
  @ext_dir = "#{node["php-fpm"]["prefix"]}/lib/php/extensions/no-debug-non-zts-20090626"
  @prefix  = node["php-fpm"]["prefix"]
end

attribute :prefix, :kind_of => String
attribute :ext_dir, :kind_of => String
attribute :package, :kind_of => String, :name_attribute => true
attribute :version, :kind_of => String
attribute :config,  :kind_of => Hash
attribute :source_dir, :kind_of => String
attribute :cflags, :kind_of => String
