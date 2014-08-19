action :create do
  path = new_resource.path

  mirror_name = node["aptly"]["mirror_name"]
  s3_mirror = node["aptly"]["s3_mirror"]
  cron_command = "MIRROR_NAME=#{mirror_name} S3_APT_MIRROR=s3://#{s3_mirror} #{path}/mirror-it.rb"

  cron_d "aptly_sync_launchpad" do
    action :create
    minute "*/30"
    user "backups"
    command cron_command
    path node["easybib_deploy"]["cron_path"]
  end

end
