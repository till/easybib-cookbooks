# S3 artifact LWRP provider. Gets app artifact (tarball) from S3.

use_inline_resources

action :sync do
  # Only get file if we don't have it already, or if we're configured
  # to overwrite.
  if ! ::File.exist?(new_resource.tarball) || new_resource.overwrite

    # Destination dir in case it doesn't exist.
    dest_dir = ::File.dirname(new_resource.tarball)
    directory dest_dir do
      owner new_resource.owner
      group new_resource.group
      mode new_resource.dir_mode
      recursive true
      not_if "test -d #{dest_dir}"
    end

    opscode_extensions_remote_s3_file new_resource.tarball do
      owner new_resource.owner
      group new_resource.group
      mode new_resource.mode
      aws_access_key_id new_resource.aws_access_key_id
      aws_secret_access_key new_resource.aws_secret_access_key
      bucket new_resource.aws_bucket
      object object_name(new_resource)
      seconds_to_expire 120
    end
  end

  # TODO: Add some smarts. Download to a tmp dir then move the file so if
  # download fails there won't be a stale file.
end

# AWS object name
def object_name(new_resource)
    tarball = "#{new_resource.name}-#{new_resource.revision}.tar.gz"
    platform = "#{node['platform']}-#{node['platform_version']}"
    arch = node['kernel']['machine']
    "#{new_resource.artifacts_root}/#{platform}/#{arch}/#{new_resource.name}/#{tarball}"
end
