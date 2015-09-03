actions :install
default_action :install

attribute :distination, :kind_of => String, :required => true

attribute :artifact, :kind_of => String

attribute :reboot, :kind_of => [TrueClass, FalseClass], :default => true
