actions :add

attribute :app_name, :kind_of => String, :name_attribute => true
attribute :path, :kind_of => String
attribute :config, :kind_of => Hash, :default => {}

def initialize(*args)
  super
  @action = :add
end