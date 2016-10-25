name              'fail2ban'
maintainer        'Opscode, Inc.'
maintainer_email  'cookbooks@opscode.com'
license           'Apache 2.0'
description       'Installs and configures fail2ban'
version           '2.2.1'
source_url 'https://github.com/chef-cookbooks/fail2ban' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/fail2ban/issues' if respond_to?(:issues_url)
recipe 'fail2ban', 'Installs and configures fail2ban'

%w(debian ubuntu).each do |os|
  supports os
end
