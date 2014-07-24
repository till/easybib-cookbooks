module EasyBib
  def amd64?(node = self.node)
    if node["kernel"]["machine"] == "x86_64"
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

    false
  end

  def has_env?(app, node = self.node)
    if !node.attribute?(app)
      return false
    end

    if node[app]["env"]
      return true
    end

    false
  end

  def allow_deploy(application, requested_application, requested_role = nil, node = self.node)
    if !is_aws(node)
      return false
    end

    instance_roles = get_instance_roles(node)
    cluster_name   = get_cluster_name(node)

    Chef::Log.info(
      "deploy #{requested_application} - requested app: #{application}, role: #{instance_roles} in #{cluster_name}"
    )

    if cluster_name != node["easybib"]["cluster_name"]
      Chef::Log.info("deploy #{requested_application} - wrong cluster_name")
      return false
    end
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
      fail "Unknown value type supplied for requested_role in allow_deploy"
    end
  end

  def is_app_configured_for_stack(application, requested_application, requested_role, instance_roles)
    case application
    when requested_application
      if !instance_roles.include?(requested_role)
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

  def get_env_for_nginx(app, node = self.node)
    ::EasyBib::Config.get_env("nginx", app, node)
  end

  def get_env_for_shell(app, node = self.node)
    ::EasyBib::Config.get_env("shell", app, node)
  end

  def get_domain_conf(node_attribute, node = self.node)
    get_conf_from_env(node_attribute, "domain", node)
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

    db_conf
  end

  def get_cluster_name(node = self.node)
    if node["opsworks"] && node["opsworks"]["stack"]
      return node["opsworks"]["stack"]["name"]
    end
    if node["easybib"] && node["easybib"]["cluster_name"]
      return node["easybib"]["cluster_name"]
    end
    ::Chef::Log.error("Unknown environment. (get_cluster_name)")

    ""
  end

  def get_deploy_user(node = self.node)
    if node["opsworks"]
      return node["opsworks"]["deploy_user"]
    end
    ::Chef::Log.debug("Unknown environment. (get_deploy_user)")
  end

  def get_instance_roles(node = self.node)
    if node["opsworks"]
      return node["opsworks"]["instance"]["layers"]
    end
    ::Chef::Log.debug("Unknown environment. (get_instance_roles)")
  end

  def get_instance(node = self.node)
    if node["opsworks"]
      return node["opsworks"]["instance"]
    end
    ::Chef::Log.debug("Unknown environment. (get_instance)")
  end

  def is_aws(node = self.node)
    if node["opsworks"]
      return true
    end
    false
  end

  def to_php_yaml(obj)
    # This is an ugly quick hack: Ruby Yaml adds object info !map:Chef::Node::ImmutableMash which
    # the Symfony Yaml parser doesnt like. So lets remove it. First Chef 11.4/Ruby 1.8,
    # then Chef 11.10/Ruby 2.0
    yaml    = YAML.dump(obj)
    content = yaml.gsub('!map:Chef::Node::ImmutableMash', '')
    content.gsub('!ruby/hash:Chef::Node::ImmutableMash', '')
  end

  extend self

  protected

  def build_nginx_config(key, value)
    "fastcgi_param #{key} \"#{value}\";\n"
  end
end

class Chef::Recipe
  include EasyBib
end
