actions :install, :setup

def initialize(*args)
  super
  @action  = :install
  @version = ""
end

attribute :package, :kind_of => String, :name_attribute => true
