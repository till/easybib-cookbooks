# Service package LWRP provider. Deploys a 'service' tarball.
# Artifacts get extracted under /<root>/_releases/<app>/<revision>.
# Then the deployed artifact is linked at /<root>/<app>.
# If configured, a hipchat notification is also sent.

# NOTE: artifact tarball should be rooted at <app_name>!

# TODO: don't retain all releases, only keep <X> most recent.
# TODO: should be its own cookbook. Factor out when tested.

action :deploy do
    # /<root>/_releases/<app>/<revision>
    dest_dir = dest_dir_name(new_resource)

    if new_resource.force_deploy
      Chef::Log.info("*** Force deploy of #{new_resource.tarball} requested")
      # Start from a clean directory.
      execute "remove_#{dest_dir}" do
        command "rm -Rf #{dest_dir}"
        only_if "test -d #{dest_dir}"
      end
    end

    directory dest_dir do
      owner new_resource.owner
      group new_resource.group
      mode "0755"
      recursive true
      notifies :run, "execute[untar_#{new_resource.name}]", :immediately
    end

    execute "untar_#{new_resource.name}" do
      action :nothing
      command "tar xzf #{new_resource.tarball}"
      cwd dest_dir
    end

    link "link_current_#{new_resource.name}" do
      to "#{dest_dir}/#{new_resource.name}"
      target_file service_link_path(new_resource)
      owner new_resource.owner
      group new_resource.group
    end

    # TODO: We could define further standards for a service pkg, like
    # a start script so we could configure the service to start
    # automatically.

    # Technically this doesn't mean the app was deployed, just the pkg.
    # So not necessarily active... But where else can I put this?
    if new_resource.hipchat_key
      deployment_notification("link[link_current_#{new_resource.name}]") do
        app_environment new_resource.app_environment
        service_name new_resource.name
        # Link resource doesn't have a revision attribute, so we set
        # the message instead.
        message "Deployed revision #{new_resource.revision} of #{new_resource.name} on #{node[:fqdn]} in #{new_resource.app_environment}"
        estatsd_host new_resource.estatsd_host
        hipchat_key new_resource.hipchat_key
      end
    else
      Chef::Log.info("*** No hipchat key for #{new_resource.tarball} deployment. Skipping notification.")
    end
end


action :delete do
    link "delete #{new_resource.name} link" do
        target_file service_link_path(new_resource)
        action :delete
    end

    directory "delete #{new_resource.name} releases" do
        target releases_dir_name(new_resource)
        action :delete
        recursive true
    end
end


# Where releases for this pkg get extracted.
def releases_dir_name(new_resource)
    "#{new_resource.root_dir}/_releases/#{new_resource.name}"
end

# Where the current release gets extracted.
def dest_dir_name(new_resource)
    releases_dir = releases_dir_name(new_resource)
    "#{releases_dir}/#{new_resource.revision}"
end

# Where the current release gets linked.
def service_link_path(new_resource)
    "#{new_resource.root_dir}/#{new_resource.name}"
end
