module EasyBib

  def amd64?(node = self.node)
    if node["kernel"]["machine"] == "x86_64"
      return true
    end
    return false
  end

  def has_env?(app, node = self.node)

    if !node.attribute?(app)
      return false
    end

    if node[app]["env"]
      return true
    end

    return false
  end
  
  def allow_deploy(application, requested_application, requested_role = nil)
    
    if requested_role.nil?
      requested_role = requested_application
    end
    
    instance_roles = get_instance_roles()
    cluster_name   = get_cluster_name()
    
    Chef::Log.info("deploy #{requested_application} - request to deploy app: #{application}, role: #{instance_roles} in #{cluster_name}")
    
    if cluster_name != self.node["easybib"]["cluster_name"]
      Chef::Log.debug("deploy #{requested_application} - wrong cluster_name")
      return false
    end

    case application
    when requested_application
      return false unless instance_roles.include?(requested_role)
    else
      Chef::Log.debug("deploy #{requested_application} - #{application} (in #{cluster_name}) skipped")
      return false
    end
    
    Chef::Log.debug("deploy #{requested_application} - allowing deploy")
    
    return true
  end

  def get_env_for_nginx(app, node = self.node)
    return get_env(app, node, "nginx")
  end

  def get_env_for_shell(app, node = self.node)
    return get_env(app, node, "shell")
  end

  def get_env(app, node, config_type)
    config = ""

    if !node.attribute?(app)
      return config
    end

    if node[app]["env"].nil?
      raise "Attribute 'env' for application '#{app}' is not defined!"
    end

    if !["nginx", "shell"].include?(config_type)
      raise "Unknown configuration type: #{config_type}."
    end

    node[app]["env"].each_pair do |section, data|

      data.each_pair do |config_key, config_value|
        if config_value.is_a?(String)
          var = sprintf('%s_%s', section.upcase, config_key.upcase)

          config << build_nginx_config(var, config_value) if config_type == "nginx"
          config << build_shell_config(var, config_value) if config_type == "shell"

          next
        end

        config_value.each_pair do |sub_key, sub_value|
          var = sprintf('%s_%s_%s', section.upcase, config_key.upcase, sub_key.upcase)

          config << build_nginx_config(var, sub_value) if config_type == "nginx"
          config << build_shell_config(var, sub_value) if config_type == "shell"
        end

      end
    end

    return config

  end

  def get_domain_conf(node_attribute, node = self.node)
    return get_conf_from_env(node_attribute, "domain", node)
  end

  def get_conf_from_env(node_attribute, node_key, node)

    db_conf = ""

    if !node.attribute?(node_attribute)
      return db_conf
    end

    env_config = node[node_attribute]
    if env_config[node_key].nil? || env_config[node_key].empty?
      return db_conf
    end

    config = env_config[node_key]

    if ['domain', 'aws'].include?(node_key)
      domain = config
      domain.each_key do |app_name|

        app_host = domain[app_name]

        db_conf << build_nginx_config("#{node_key.upcase}_#{app_name}", app_host)
      end

      return db_conf
    end

    config.each_key do |connection_id|

      connection_config = config[connection_id]

      connection_config.each_key do |connection_config_key|

        connection_config_value = connection_config[connection_config_key]

        db_conf << build_nginx_config(
          "#{connection_id}_#{connection_config_key}",
          connection_config_value
        )
      end
    end

    return db_conf
  end

  def build_shell_config(key, value)
    return "export #{key}=\"#{value}\"\n"
  end

  def build_nginx_config(key, value)
    return "fastcgi_param #{key} \"#{value}\";\n"
  end

  def get_cluster_name(node = self.node)
    if node["scalarium"]
      return node["scalarium"]["cluster"]["name"]
    end
    if node["opsworks"] && node["opsworks"]["stack"]
      return node["opsworks"]["stack"]["name"]
    end
    if node["easybib"] && node["easybib"]["cluster_name"]
      return node["easybib"]["cluster_name"]
    end
    ::Chef::Log.error("Unknown environment.")

    return ""

  end

  def get_deploy_user(node = self.node)
    if node["scalarium"]
      return node["scalarium"]["deploy_user"]
    end
    if node["opsworks"]
      return node["opsworks"]["deploy_user"]
    end
    ::Chef::Log.debug("Unknown environment.")
  end

  def get_instance_roles(node = self.node)
    if node["scalarium"]
      return node["scalarium"]["instance"]["roles"]
    end
    if node["opsworks"]
      return node["opsworks"]["instance"]["layers"]
    end
    ::Chef::Log.debug("Unknown environment.")
  end

  def get_instance(node = self.node)
    if node["scalarium"]
      return node["scalarium"]["instance"]
    end
    if node["opsworks"]
      return node["opsworks"]["instance"]
    end
    ::Chef::Log.debug("Unknown environment.")
  end

  def is_aws(node = self.node)
    if node["scalarium"]
      return true
    end
    if node["opsworks"]
      return true
    end
    return false
  end

  extend self
end

class Chef::Recipe
  include EasyBib
end
