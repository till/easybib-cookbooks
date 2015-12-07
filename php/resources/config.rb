actions :generate

def initialize(*args)
  super
  @action      = :generate
  @prefix_dir  = node['php-fpm']['prefix']
end

attribute :name, :kind_of => String, :named_attribute => true
attribute :prefix_dir, :kind_of => String
attribute :config, :kind_of => Hash
attribute :extension_path, :kind_of => String, :default => nil
attribute :load_extension, :kind_of => [TrueClass, FalseClass], :default => false
attribute :zend_extension, :kind_of => [TrueClass, FalseClass], :default => false
