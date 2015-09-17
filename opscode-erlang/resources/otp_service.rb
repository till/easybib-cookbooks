# OTP service LWRP
#
# NOTE: This LWRP uses node attributes as defaults. See
# providers/otp_service.rb for more details.
#

actions :deploy, :delayed_restart, :immediate_restart, :stop, :start
default_action :deploy

# App name used to derive standard values.
attribute :name, :kind_of => String, :name_attribute => true

attribute :revision, :kind_of => String, :required => true
attribute :tarball, :kind_of => String, :required => true
attribute :source, :kind_of => String, :required => true

# Force deployment.
# Normally the deploy occurs only if the revision has not been
# deployed yet. Set this to true to force re-deploying on top
# of an existing deploy.
attribute :force_deploy, :kind_of => [TrueClass, FalseClass], :default => false

# In development mode, code is deployed from source (instead of artifact).
attribute :development_mode, :kind_of => [TrueClass, FalseClass], :default => false

# S3 parameters when getting tarball from S3
attribute :aws_access_key_id, :kind_of => String
attribute :aws_secret_access_key, :kind_of => String
attribute :aws_bucket, :kind_of => String

# Root of /srv tree, not app-specific.
attribute :root_dir, :kind_of => String, :required => true

# Location of etc dir (linked inside release, optional).
attribute :etc_dir, :kind_of => String

# Location of log dir (linked inside release, optional).
attribute :log_dir, :kind_of => String

# Service config
attribute :sys_config, :kind_of => Hash, :required => true

# Logging options
attribute :console_log_count, :kind_of => Integer, :required => true
attribute :console_log_mb, :kind_of => Integer, :required => true
attribute :error_log_count, :kind_of => Integer, :required => true
attribute :error_log_mb, :kind_of => Integer, :required => true

# User and group that own the files.
attribute :owner, :kind_of => String, :required => true
attribute :group, :kind_of => String, :required => true

# For hipchat notifications:
attribute :estatsd_host, :kind_of => String
attribute :hipchat_key, :kind_of => String
attribute :app_environment, :kind_of => String, :default => node.chef_environment

# Set to force removing the existing src dir if it exists.
# This is handy to force a build from scratch when using git.
# Careful! Don't delete your WIP source!
attribute :force_clean_src, :kind_of => [TrueClass, FalseClass], :default => false

# Tool that built the release:
# reltool or relx
attribute :release_type, :equal_to => [:reltool, :relx], :default => :reltool
