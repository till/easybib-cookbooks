name              'ies-chef-handler-sns'
maintainer        'Brian Wiborg'
maintainer_email  'bwiborg@chegg.com'
license           'Apache 2.0'
description       'Wrapper around chef_handler_sns'
version           '0.0.1'

%w(ubuntu).each do |os|
  supports os
end

depends 'chef_handler_sns'
