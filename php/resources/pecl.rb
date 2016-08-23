actions :install, :copy, :compile

def initialize(*args)
  super
  @action  = :install
  @prefix  = node['php-fpm']['prefix']
end

attribute :prefix, :kind_of => String
attribute :package, :kind_of => String, :name_attribute => true
attribute :version, :kind_of => String, :default => nil
attribute :config,  :kind_of => Hash
attribute :source_dir, :kind_of => String, :default => ''
attribute :cflags, :kind_of => String
attribute :ext_file, :kind_of => String, :default => nil
