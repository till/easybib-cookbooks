# OTP Release

actions :deploy, :delayed_restart, :immediate_restart, :stop, :start
default_action :deploy

# App name used to derive standard values.
attribute :name, :kind_of => String, :name_attribute => true

attribute :revision, :kind_of => String, :required => true
attribute :tarball, :kind_of => String, :required => true
attribute :source, :kind_of => String, :required => true

# In development mode, code is deployed from source (instead of artifact).
# attribute :development_mode, :kind_of => [TrueClass, FalseClass], :default => false

# S3 parameters when getting tarball from S3
# attribute :aws_access_key_id, :kind_of => String
# attribute :aws_secret_access_key, :kind_of => String
# attribute :aws_bucket, :kind_of => String

# Root of /srv tree, not app-specific.
attribute :root_dir, :kind_of => String, :required => true

# Location of etc dir (linked inside release, optional).
# attribute :etc_dir, :kind_of => String

# Location of log dir (linked inside release, optional).
# attribute :log_dir, :kind_of => String

# Service config
# attribute :sys_config, :kind_of => Hash, :required => true

# Logging options
# attribute :console_log_count, :kind_of => Integer, :required => true
# attribute :console_log_mb, :kind_of => Integer, :required => true
# attribute :error_log_count, :kind_of => Integer, :required => true
# attribute :error_log_mb, :kind_of => Integer, :required => true

# User and group that own the files.
attribute :owner, :kind_of => String, :required => true
attribute :group, :kind_of => String, :required => true

attribute :release_type, :equal_to => [:reltool, :relx], :default => :relx
