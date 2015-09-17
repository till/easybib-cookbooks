# OTP release artifact LWRP. Builds or retrieves a release artifact.

actions :create
default_action :create

# App name
attribute :name, :kind_of => String, :name_attribute => true

# The resulting tarball.
attribute :tarball, :kind_of => String, :required => true

# Build from source in dev mode
attribute :development_mode, :kind_of => [TrueClass, FalseClass], :default => false

# Source can be a local dir or a git repo.
attribute :source, :kind_of => String, :required => true
attribute :revision, :kind_of => String, :required => true

# Set to force removing the existing src dir if it exists.
attribute :force_clean_src, :kind_of => [TrueClass, FalseClass], :default => false

# S3 parameters when getting tarball from S3
attribute :aws_access_key_id, :kind_of => String
attribute :aws_secret_access_key, :kind_of => String
attribute :aws_bucket, :kind_of => String

# File ownership and permissions
attribute :owner, :kind_of => String, :required => true
attribute :group, :kind_of => String, :required => true
attribute :dir_mode, :kind_of => String, :default => "0755"
attribute :file_mode, :kind_of => String, :default => "0644"

# Optionally override where source goes when using git.
attribute :src_root_dir, :kind_of => String, :default => "/usr/local/src"
