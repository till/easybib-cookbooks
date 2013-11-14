actions :discover

def initialize(*args)
  super
  @action  = :discover
end

attribute :repository, :kind_of => String, :name_attribute => true
