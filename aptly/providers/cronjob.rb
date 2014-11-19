action :create do
  path = new_resource.path

  mirror_name = node['aptly']['mirror_name']
  s3_mirror = "#{node['aptly']['s3_mirror']}:#{node['aptly']['s3_mirror_prefix']}"
  pw = node['aptly']['sign_pass']

  template ' #{path}/run.sh' do
    source 'run.sh.erb'
    cookbook 'aptly'
    owner 'root'
    group 'root'
    mode 00700
    variables(
      :pw => pw,
      :mirror_name => mirror_name,
      :s3_mirror => s3_mirror,
      :path => path
      )
    action :create
  end

  cron_command = "screen -d -m #{path}/run.sh"

  cron_d 'aptly_sync_launchpad' do
    action :create
    minute '0'
    hour '5'
    user 'root'
    command cron_command
    path node['easybib_deploy']['cron_path']
  end
  new_resource.updated_by_last_action(true)

end
