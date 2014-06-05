name             'chef_handler_sns'
maintainer       'Onddo Labs, Sl.'
maintainer_email 'team@onddo.com'
license          'Apache 2.0'
description      'Installs and enables chef-handler-sns'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0' # WiP

depends 'xml'
depends 'chef_handler'

recipe 'chef_handler_sns::default', 'Installs and loads the Chef SNS Handler.'

provides 'chef_handler_sns'

attribute 'chef_handler_sns/topic_arn',
  :display_name => 'chef-handler-sns topic_arn',
  :description => 'AWS topic ARN name (required).',
  :type => 'string',
  :required => 'required'

attribute 'chef_handler_sns/access_key',
  :display_name => 'chef-handler-sns access_key',
  :description => 'AWS access key (required, but will try to read it from ohai with IAM roles).',
  :type => 'string',
  :required => 'optional',
  :calculated => true

attribute 'chef_handler_sns/secret_key',
  :display_name => 'chef-handler-sns secret_key',
  :description => 'AWS secret key (required, but will try to read it from ohai with IAM roles).',
  :type => 'string',
  :required => 'optional',
  :calculated => true

attribute 'chef_handler_sns/token',
  :display_name => 'chef-handler-sns token',
  :description => 'AWS security token (read from ohai with IAM roles).',
  :type => 'string',
  :required => 'optional',
  :calculated => true

attribute 'chef_handler_sns/region',
  :display_name => 'chef-handler-sns region',
  :description => 'AWS region.',
  :type => 'string',
  :required => 'optional',
  :calculated => true

attribute 'chef_handler_sns/subject',
  :display_name => 'chef-handler-sns subject',
  :description => 'Message subject string in erubis format.',
  :type => 'string',
  :required => 'optional',
  :calculated => true

attribute 'chef_handler_sns/body_template',
  :display_name => 'chef-handler-sns body_template',
  :description => 'Full path of an erubis template file to use for the message body.',
  :type => 'string',
  :required => 'optional',
  :calculated => true

attribute 'chef_handler_sns/supports',
  :display_name => 'chef-handler supports',
  :description => 'Type of Chef Handler to register as, ie :report, :exception or both.',
  :type => 'hash',
  :required => 'optional',
  :default => '{ "exception" => true }'

attribute 'chef_handler_sns/version',
  :display_name => 'chef-handler-sns version',
  :description => 'chef-handler-sns gem version to install.',
  :type => 'string',
  :required => 'optional',
  :calculated => true
