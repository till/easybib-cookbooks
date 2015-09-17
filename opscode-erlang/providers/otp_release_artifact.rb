# OTP release artifact LWRP provider. Builds or retrieves a release artifact.

use_inline_resources

action :create do
  if new_resource.development_mode
    # In dev we build from source. Source can be a local
    # directory, e.g. "/vagrant", or a git repo.
    # Generates a tar ball appname-revision.tgz and puts
    # it in dest_dir.
    Chef::Log.info("*** In development mode, build #{new_resource.tarball} from #{new_resource.source}.")
    opscode_erlang_otp_build new_resource.name do
      action :build
      tarball new_resource.tarball
      source new_resource.source
      revision new_resource.revision
      force_clean_src new_resource.force_clean_src
      owner new_resource.owner
      group new_resource.group
      src_root_dir new_resource.src_root_dir
    end
  else
    # Otherwise we deploy from artifact.
    Chef::Log.info("*** Getting #{new_resource.name}-#{new_resource.revision} OTP release artifact from S3.")
    opscode_erlang_s3_artifact new_resource.name do
      action :sync
      revision new_resource.revision
      tarball new_resource.tarball
      owner new_resource.owner
      group new_resource.group
      aws_bucket new_resource.aws_bucket
      aws_access_key_id new_resource.aws_access_key_id
      aws_secret_access_key new_resource.aws_secret_access_key
    end
  end
end
