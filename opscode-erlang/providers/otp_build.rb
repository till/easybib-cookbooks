# OTP build LWRP
#
# Build from source, either a local dir or a git repo.
# Results in a tarball.
#

use_inline_resources

action :build do
  @run_context.include_recipe "erlang_binary::default"
  @run_context.include_recipe "erlang_binary::rebar"

  # destination dir in case it doesn't exist
  dest_dir = ::File.dirname(new_resource.tarball)
  directory dest_dir do
    owner new_resource.owner
    group new_resource.group
    mode new_resource.dir_mode
    recursive true
    not_if "test -d #{dest_dir}"
  end

  if new_resource.source =~ /^git/
    # Source is a git reference. Sync git repo.
    @run_context.include_recipe "git"
    src_dir = "#{new_resource.src_root_dir}/#{new_resource.name}"
    git_source_repo src_dir
  else
    # source is a local directory
    src_dir = new_resource.source
    ruby_block "signal_rebuild" do
      block do
        Chef::Log.info("*** Signalling a rebuild of #{new_resource.source}")
      end
      notifies :create, "ruby_block[rebuild_#{new_resource.name}]", :immediately
    end
  end

  # Encapsulates clean build logic.
  ruby_block "cleanbuild_#{new_resource.name}" do
    block do
      Chef::Log.info("*** Clean build #{new_resource.name}")
    end
    notifies :run, "execute[distclean_#{new_resource.name}]", :immediately
    notifies :create, "ruby_block[rebuild_#{new_resource.name}]", :immediately
    action :nothing
  end

  # Encapsulates build logic and service restart.
  ruby_block "rebuild_#{new_resource.name}" do
    block do
      Chef::Log.info("*** Rebuild #{new_resource.name}")
    end
    notifies :run, "execute[rel_#{new_resource.name}]", :immediately
    notifies :run, "execute[tar_#{new_resource.name}]", :immediately
    action :nothing
  end

  # erlexec needs HOME env var to be set. If it's not set, it errors out.
  # This seems to happen when chef-client runs daemonized.
  unless ENV['HOME']
    environment({'HOME' => '/root'})
  end

  # `make distclean`
  execute "distclean_#{new_resource.name}" do
    command "make distclean"
    cwd src_dir
    action :nothing
  end

  # `make relclean rel`
  execute "rel_#{new_resource.name}" do
    command "make relclean rel"
    cwd src_dir
    action :nothing
  end

  # tar it up
  execute "tar_#{new_resource.name}" do
    command "tar czf #{new_resource.tarball} #{new_resource.name}"
    cwd "#{src_dir}/rel"
    action :nothing
  end
end

def git_source_repo(src_dir)
  if new_resource.force_clean_src
    Chef::Log.info("*** Force cleanup of #{src_dir}")
    execute "cleanup_#{new_resource.name}_src" do
      command "rm -Rf #{src_dir}"
    end
  end

  directory src_dir do
    owner new_resource.owner
    group new_resource.group
    mode new_resource.dir_mode
    recursive true
  end

  git "#{new_resource.name}_source" do
    destination src_dir
    repository new_resource.source # "git@github.com:opscode/#{app_name}.git"
    revision new_resource.revision
    user new_resource.owner
    group new_resource.group
    notifies :create, "ruby_block[cleanbuild_#{new_resource.name}]", :immediately
  end
end
