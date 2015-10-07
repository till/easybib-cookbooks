# installs our ruby opsworks helper gem

# Warning: action :upgrade should always upgrade, but doesnt seem to do so,
# so we first uninstall it. Since it is not yet installed during setup, we ignore failure.

chef_gem 'Remove: BibOpsworks' do
  package_name 'BibOpsworks'
  action :remove
  only_if do
    ::EasyBib.is_aws(node)
  end
  ignore_failure true
end

chef_gem 'Update: BibOpsworks' do
  package_name 'BibOpsworks'
  action :upgrade
  only_if do
    ::EasyBib.is_aws(node)
  end
end