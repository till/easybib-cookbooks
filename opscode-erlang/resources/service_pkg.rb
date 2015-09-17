# Service package LWRP

actions :deploy, :delete, :default => :deploy

# app name used to derive standard values
attribute :name, :kind_of => String, :name_attribute => true
attribute :revision, :kind_of => String, :required => true
attribute :tarball, :kind_of => String, :required => true

# Force deployment
attribute :force_deploy, :kind_of => [TrueClass, FalseClass], :default => false

# Root directory. Defaults to /srv.
attribute :root_dir, :kind_of => String, :default => "/srv"

# User and group that own the files
attribute :owner, :kind_of => String, :required => true
attribute :group, :kind_of => String, :required => true

# For hipchat notifications:
attribute :estatsd_host, :kind_of => String
attribute :hipchat_key, :kind_of => String
attribute :app_environment, :kind_of => String, :default => node.chef_environment
