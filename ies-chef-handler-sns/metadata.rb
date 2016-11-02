name              'ies-chef-handler-sns'
maintainer        'Brian Wiborg'
maintainer_email  'bwiborg@chegg.com'
license           'Apache 2.0'
description       'Wrapper around chef_handler_sns'
version           '0.0.1'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

%w(ubuntu).each do |os|
  supports os
end

depends 'chef_handler_sns'
