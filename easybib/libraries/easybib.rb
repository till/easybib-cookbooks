module EasyBib
  def amd64?(node = self.node)
    if node['kernel']['machine'] == 'x86_64'
      return true
    end
    false
  end

  def deploy_crontab?(instance_roles, cronjob_role)
    if cronjob_role.nil?
      return true
    end

    if instance_roles.include?(cronjob_role)
      return true
    end

    Chef::Log.info('Instance is not in a cronjob role, skippings cronjob installs')

    false
  end

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

  def allow_deploy(application, requested_application, requested_role = nil, node = self.node)
    unless is_aws(node)
      Chef::Log.debug('We are not running in a cloud environment, skipping deploy.')
      return false
    end

    instance_roles = get_instance_roles(node)

    Chef::Log.info(
      "deploy #{requested_application} - requested app: #{application}, role: #{instance_roles}"
    )

    if requested_application.is_a?(String)
      if requested_role.nil?
        requested_role = requested_application
      end
      return is_app_configured_for_stack(application, requested_application, requested_role, instance_roles)
    elsif requested_application.is_a?(Array)
      allow = false
      requested_application.each do |current_requested_application|
        if requested_role.nil?
          requested_role = current_requested_application
        end
        allow_current = is_app_configured_for_stack(application, current_requested_application, requested_role, instance_roles)
        # allow if any of requested_applications is allowed, so lets use OR:
        allow ||= allow_current
      end
      return allow
    else
      fail 'Unknown value type supplied for requested_role in allow_deploy'
    end
  end

  def is_app_configured_for_stack(application, requested_application, requested_role, instance_roles)
    case application
    when requested_application
      unless instance_roles.include?(requested_role)
        irs = instance_roles.inspect
        Chef::Log.info("deploy #{requested_application} - skipping: #{requested_role} is not in (#{irs})")
        return false
      end
    else
      Chef::Log.info("deploy #{requested_application} - #{application} skipped")
      return false
    end

    Chef::Log.info("deploy #{requested_application} - allowing deploy")
    true
  end

  def get_cluster_name(node = self.node)
    if node['opsworks'] && node['opsworks']['stack']
      return node['opsworks']['stack']['name']
    end
    if node['easybib'] && node['easybib']['cluster_name']
      return node['easybib']['cluster_name']
    end
    ::Chef::Log.error('Unknown environment. (get_cluster_name)')

    ''
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
    if node['opsworks']
      return node['opsworks']['instance']
    end
    ::Chef::Log.debug('Unknown environment. (get_instance)')
  end

  def is_aws(node = self.node)
    if node['opsworks']
      return true
    end
    false
  end

  def get_hostname(fail_if_nil = false)
    if !get_cluster_name.empty?
      instance    = get_instance
      my_hostname = instance['hostname']
    else
      # node.json
      if node['server_name']
        my_hostname = node['server_name']
      # from 'ohai'
      else
        my_hostname = node['hostname']
      end
    end

    if fail_if_nil == true && my_hostname.nil?
      Chef::Application.fatal!('Can not determine the hostname of this node!')
    end

    return my_hostname
  end

  extend self
end

class Chef::Recipe
  include EasyBib
end
