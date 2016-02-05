unless node['deploy'].nil?
  node['deploy'].each do |application, deploy|
    if deploy['home'].nil? || deploy['home'] == '/home/www-data'
      Chef::Log.debug('home was empty or /home/www, changing it to /var/www')
      node.default['deploy'][application]['home'] = '/var/www'
    end
  end
end

# fixes "Could not load host key: /etc/ssh/ssh_host_ed25519_key" error
execute 'Generate missing ssh host keys' do
  command 'ssh-keygen -A'
  ignore_failure true
end

# ensures mounting of all devices:
# - https://imagineeasy.atlassian.net/browse/DEVOPS-77
if is_aws
  directory '/mnt2' do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
    only_if do
      File.exist?('/dev/xvdc')
    end
  end
  execute 'format xvdc if required' do
    # AWS auto-formats its volumes with ext3. We want ext4 for performance
    # reasons. If we find an ext3 formatted xvdc device, we assume that the
    # volume is "new" (as in: has no data yet) and format it with ext4.
    command '(([[ -a /dev/xvdc ]] && file -sL /dev/xvdc | grep "\<ext3\>") && mkfs.ext4 /dev/xvdc) || true'
    only_if do
      File.exist?('/dev/xvdc')
    end
  end
  template '/etc/fstab' do
    source 'fstab'
    owner 'root'
    group 'root'
    mode '0644'
    only_if do
      File.exist?('/dev/xvdc')
    end
  end
  execute 'mount all' do
    command 'mount -a'
  end
end
