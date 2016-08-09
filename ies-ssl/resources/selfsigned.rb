actions :create

default_action :create

attribute :domain, :name_attribute => true
attribute :country, :kind_of => String, :default => 'DE'
attribute :state, :kind_of => String, :default => 'Berlin'
attribute :city, :kind_of => String, :default => 'Berlin'
attribute :organization, :kind_of => String, :default => 'Chegg Inc.'
attribute :unit, :kind_of => String, :default => 'Engineering'
