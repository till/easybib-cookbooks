module EasyBib
  def has_role?(instance_roles, role)
    if role.nil?
      return true
    end

    if instance_roles.include?(role)
      return true
    end

    false
  end

  def has_env?(app, node = self.node)
    unless node.attribute?(app)
      return false
    end

    if node[app]['env']
      return true
    end

    false
  end

  def get_cluster_name(node = self.node)
    if node['opsworks'] && node['opsworks']['stack']
      return node['opsworks']['stack']['name']
    end
    if node['easybib'] && node['easybib']['cluster_name']
      return node['easybib']['cluster_name']
    end
    if is_aws(node)
      ::Chef::Log.error('Unknown environment. (get_cluster_name) - returning unknown')
      return ''
    else
      return 'vagrant'
    end
  end

  def get_normalized_cluster_name(node = self.node)
    cluster_name = get_cluster_name(node)
    cluster_name.downcase.gsub(/[^a-z0-9-]/, '_')
  end

  def get_deploy_user(node = self.node)
    if node['opsworks']
      return node['opsworks']['deploy_user']
    end

    ::Chef::Log.info('Unknown environment. (get_deploy_user)')

    {
      'home' => nil,
      'group' => nil,
      'user' => nil
    }
  end

  def get_instance_roles(node = self.node)
    if node['opsworks']
      return node['opsworks']['instance']['layers']
    end
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
    if node['opsworks']
      return true
    end
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
    if get_instance(node)
      opsworks_hostname = get_instance(node)['hostname']
    end
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
