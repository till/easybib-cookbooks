
actions :enable

attribute :topic_arn, :kind_of => String, :name_attribute => true
attribute :access_key, :kind_of => String, :default => nil
attribute :secret_key, :kind_of => String, :default => nil
attribute :token, :kind_of => String, :default => nil
attribute :region, :kind_of => String, :default => nil
attribute :subject, :kind_of => String, :default => nil
attribute :body_template, :kind_of => String, :default => nil

attribute :supports, :kind_of => Hash, :default => nil
attribute :version, :kind_of => String, :default => nil

def initialize(*args)
  super
  @action = :enable
end
