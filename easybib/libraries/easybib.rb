module EasyBib
  def amd64?(node = self.node)
    if node["kernel"]["machine"] == "x86_64"
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

  def allow_deploy(application, requested_application, requested_role = nil)
    if !is_aws
      return false
    end

    if requested_role.nil?
      requested_role = requested_application
    end

    instance_roles = get_instance_roles
    cluster_name   = get_cluster_name

    Chef::Log.info(
      "deploy #{requested_application} - requested app: #{application}, role: #{instance_roles} in #{cluster_name}"
    )

    if cluster_name != self.node["easybib"]["cluster_name"]
      Chef::Log.debug("deploy #{requested_application} - wrong cluster_name")
      return false
    end

    if requested_application.is_a?(String)
      return is_app_configured_for_stack(application, requested_application, requested_role, instance_roles)
    else
      # TODO: we should add a check for the var type of requested_application here, probably
      allow = false
      requested_application.each do |current_requested_application|
        allow_current = is_app_configured_for_stack(application, current_requested_application, requested_role, instance_roles)
        # allow if any of requested_applications is allowed, so lets use OR:
        allow ||= allow_current
      end
      return allow
    end
  end

  def is_app_configured_for_stack(application, requested_application, requested_role, instance_roles)
    case application
    when requested_application
      if !instance_roles.include?(requested_role)
        irs = instance_roles.inspect
        Chef::Log.debug("deploy #{requested_application} - skipping: #{requested_role} is not in (#{irs})")
        return false
      end
    else
      Chef::Log.debug("deploy #{requested_application} - #{application} (in #{cluster_name}) skipped")
      return false
    end

    Chef::Log.debug("deploy #{requested_application} - allowing deploy")
    true
  end

  def get_env_for_nginx(app, node = self.node)
    get_env(app, node, "nginx")
  end

  def get_env_for_shell(app, node = self.node)
    get_env(app, node, "shell")
  end

  def get_env(app, node, config_type)
    config = ""

    if !node.attribute?(app)
      return config
    end

    if node[app]["env"].nil?
      fail "Attribute 'env' for application '#{app}' is not defined!"
    end

    node[app]["env"].each_pair do |section, data|

      data.each_pair do |config_key, config_value|
        if config_value.is_a?(String)

          fail "The character \" is not supported as a value in the config" if config_value.match('"')

          var = sprintf('%s_%s', section.upcase, config_key.upcase)

          config << build_config(config_type, var, config_value)
          next
        end

        config_value.each_pair do |sub_key, sub_value|
          var = sprintf('%s_%s_%s', section.upcase, config_key.upcase, sub_key.upcase)

          fail "The character \" is not supported as a value in the config" if sub_value.match('"')

          config << build_config(config_type, var, sub_value)
        end

      end
    end

    config
  end

  def build_config(config_type, var, value)
    case config_type
    when "nginx"
      build_nginx_config(var, value)
    when "shell"
      build_shell_config(var, value)
    when "ini"
      build_ini_config(var, value)
    else
      fail "Unknown configuration type: #{config_type}."
    end
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

  def build_shell_config(key, value)
    "export #{key}=\"#{value}\"\n"
  end

  def build_nginx_config(key, value)
    "fastcgi_param #{key} \"#{value}\";\n"
  end

  def build_ini_config(key, value)
    "#{key} = \"#{value}\"\n"
  end

  def get_cluster_name(node = self.node)
    if node["opsworks"] && node["opsworks"]["stack"]
      return node["opsworks"]["stack"]["name"]
    end
    if node["easybib"] && node["easybib"]["cluster_name"]
      return node["easybib"]["cluster_name"]
    end
    ::Chef::Log.error("Unknown environment.")

    ""
  end

  def get_deploy_user(node = self.node)
    if node["opsworks"]
      return node["opsworks"]["deploy_user"]
    end
    ::Chef::Log.debug("Unknown environment.")
  end

  def get_instance_roles(node = self.node)
    if node["opsworks"]
      return node["opsworks"]["instance"]["layers"]
    end
    ::Chef::Log.debug("Unknown environment.")
  end

  def get_instance(node = self.node)
    if node["opsworks"]
      return node["opsworks"]["instance"]
    end
    ::Chef::Log.debug("Unknown environment.")
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
end

class Chef::Recipe
  include EasyBib
end
