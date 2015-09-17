# S3 app artifact LWRP

actions :sync, :default => :sync

# App name used to derive standard values
attribute :name, :kind_of => String, :name_attribute => true
attribute :revision, :kind_of => String, :required => true

# Destination tarball
attribute :tarball, :kind_of => String, :required => true
# By default, if the tarball exists, don't do anything.
attribute :overwrite, :kind_of => [TrueClass, FalseClass], :default => false

# User and group that own the files
attribute :owner, :kind_of => String, :required => true
attribute :group, :kind_of => String, :required => true
attribute :mode, :kind_of => String, :default => "644"
attribute :dir_mode, :kind_of => String, :default => "755"

# S3 parameters
attribute :aws_access_key_id, :kind_of => String, :required => true
attribute :aws_secret_access_key, :kind_of => String, :required => true
attribute :aws_bucket, :kind_of => String, :required => true
attribute :artifacts_root, :kind_of => String, :default => "artifacts"
