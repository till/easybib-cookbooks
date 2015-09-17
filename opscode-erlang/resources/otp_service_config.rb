# OTP service config LWRP

actions :create, :restart
default_action :create

# app name used to derive standard values
attribute :name, :kind_of => String, :name_attribute => true
attribute :revision, :kind_of => String, :required => true

# Root of /srv tree, not app-specific.
# Defaults to /srv.
attribute :root_dir, :kind_of => String, :default => "/srv"

# location of etc dir (linked inside release)
attribute :etc_dir, :kind_of => String

# location of log dir (linked inside release)
attribute :log_dir, :kind_of => String, :required => true

# Service config
attribute :sys_config, :kind_of => Hash, :required => true

# Logging options
attribute :console_log_count, :kind_of => Integer, :default => 5
attribute :console_log_mb, :kind_of => Integer, :default => 400
attribute :error_log_count, :kind_of => Integer, :default => 5
attribute :error_log_mb, :kind_of => Integer, :default => 20

# user and group that own the files
attribute :owner, :kind_of => String, :required => true
attribute :group, :kind_of => String, :required => true

# Tool that built the release:
# reltool or relx
attribute :release_type, :equal_to => [:reltool, :relx], :default => :reltool
