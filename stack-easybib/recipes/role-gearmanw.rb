include_recipe 'stack-easybib::role-phpapp'

include_recipe 'php::module-mysqli'
include_recipe 'php::module-gearman'
include_recipe 'php::module-poppler-pdf'

if is_aws
  include_recipe 'stack-easybib::deploy-gearman-worker'

  # bugfix: OPS-13425
  cron_d 'pdf_autocite_cleanup' do
    action :create
    minute '15'
    hour '*'
    day '*'
    month '*'
    weekday '*'
    user 'www-data'
    command "find /tmp/ -daystart -maxdepth 1 -mmin +240 -type f -name 'pdf-autocite*' -execdir rm -- {} \\;"
  end

else
  # we use our recipe instead of the default package, because
  # our recipe writes data to disk instead of memory, so it survives
  # a vagrant suspend
  include_recipe 'redis::default'
  include_recipe 'pecl-manager::vagrant'
end
