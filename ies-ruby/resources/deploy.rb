actions :install, :reinstall, :remove
default_action :install

attribute :desired_ruby, :kind_of => String, :name_attribute => true
attribute :rbenv_user, :kind_of => String, :default => :root
attribute :rbenv_revision, :kind_of => String, :default => 'master'
attribute :ruby_build_revision, :kind_of => String, :default => 'master'
attribute :opsworks_mandatory_ruby, :kind_of => String, :default => '2.0.0-p648'
