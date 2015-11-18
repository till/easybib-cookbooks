actions :create, :delete

default_action :create

attribute :name,                  :kind_of => String, :required => true, :name_attribute => true
attribute :value,                 :kind_of => [ String, Array ]
attribute :type,                  :kind_of => String, :required => true
attribute :ttl,                   :kind_of => Integer, :default => 3600
attribute :zone_id,               :kind_of => String
attribute :region,                :kind_of => String
