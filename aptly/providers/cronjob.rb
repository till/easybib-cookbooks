action :create do
  path = new_resource.path

  %w(55 56).each do |version|
    s3_mirror = "#{node['aptly']['s3_mirror']}:#{node['aptly']['s3_mirror_prefix']}#{version}"
    pw = node['aptly']['sign_pass']

    template "#{path}/run#{version}.sh" do
      source 'run.sh.erb'
      cookbook 'aptly'
      owner 'root'
      group 'root'
      mode 00700
      variables(
        :pw => pw,
        :s3_mirror => s3_mirror,
        :path => path
      )
      action :create
    end

    cron_command = "screen -d -m #{path}/run#{version}.sh"

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
end
