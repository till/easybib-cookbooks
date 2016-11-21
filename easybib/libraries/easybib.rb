module EasyBib
  def has_role?(instance_roles, role)
    return true if role.nil?

    return true if instance_roles.include?(role)

    false
  end

  def has_env?(app, node = self.node)
    return false unless node.attribute?(app)

    return true if node[app]['env']

    false
  end

  def get_cluster_name(node = self.node)
    if node['opsworks'] && node['opsworks']['stack']
      return node['opsworks']['stack']['name']
    end
    if node['easybib'] && node['easybib']['cluster_name']
      return node['easybib']['cluster_name']
    end

    return 'vagrant' unless is_aws(node)

    ::Chef::Log.error('Unknown environment. (get_cluster_name) - returning unknown')
    ''
  end

  def get_normalized_cluster_name(node = self.node)
    cluster_name = get_cluster_name(node)
    cluster_name.downcase.gsub(/[^a-z0-9-]/, '_')
  end

  def get_deploy_user(node = self.node)
    return node['opsworks']['deploy_user'] if node['opsworks']

    ::Chef::Log.info('Unknown environment. (get_deploy_user)')

    {
      'home' => nil,
      'group' => nil,
      'user' => nil
    }
  end

  def get_instance_roles(node = self.node)
    return node['opsworks']['instance']['layers'] if node['opsworks']
    ::Chef::Log.debug('Unknown environment. (get_instance_roles)')
  end

  def get_instance(node = self.node)
    if node.fetch('opsworks', {})['instance']
      return node['opsworks']['instance']
    end
    ::Chef::Log.debug('Unknown environment. (get_instance)')
    false
  end

  def is_aws(node = self.node)
    return true if node['opsworks']
    false
  end

  # Determines the hostname of the current node
  #
  # fail_if_nil - if true, will raise fatal if hostname cannot be
  #               determined
  #
  # @return [String]
  def get_hostname(node = self.node, fail_if_nil = false)
    opsworks_hostname = false
    opsworks_hostname = get_instance(node)['hostname'] if get_instance(node)
    my_hostname = if opsworks_hostname
                    opsworks_hostname
                  elsif node['server_name']
                    node['server_name']
                  # from 'ohai'
                  else
                    node['hostname']
                  end

    if fail_if_nil == true && my_hostname.nil?
      Chef::Application.fatal!('Can not determine the hostname of this node!')
    end

    my_hostname
  end

  def get_awsregion(node = self.node)
    node['opsworks']['instance']['region']
  end

  def get_opsworks_activity(node = self.node)
    node['opsworks']['activity']
  end

  # constructs an almost FQDN (except for the actual zone name)
  def get_record_name(node = self.node)
    instance = get_instance(node)
    host_name = get_hostname(node, true)
    stack_name = get_normalized_cluster_name(node)
    region_id = instance['region']

    "#{host_name}.#{stack_name}.#{region_id}"
  end

  extend self
end

Chef::Provider.send(:include, ::EasyBib)
Chef::Recipe.send(:include, ::EasyBib)
Chef::Resource.send(:include, ::EasyBib)
