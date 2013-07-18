module EasyBib

  def amd64?(node = self.node)
    if node[:kernel][:machine] == "x86_64"
      return true
    end
    return false
  end

  def get_aws_conf(node_attribute, node = self.node)
    return get_conf_from_env(node_attribute, "aws", node)
  end

  def get_db_conf(node_attribute, node = self.node)
    return get_conf_from_env(node_attribute, "database", node)
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
      domain.each do |app_name, app_host|
        app_host = domain[app_name]
        db_conf << build_nginx_config("#{node_key.upcase}_#{app_name}", app_host)
      end

      return db_conf
    end

    database = config

    database.each do |connection_id,connection_nil|

      connection_config = database[connection_id]

      connection_config.each do |connection_config_key,connection_config_value|

        connection_config_value = connection_config[connection_config_key]

        db_conf << build_nginx_config(
          "#{connection_id}_#{connection_config_key}",
          connection_config_value
        )
      end
    end

    return db_conf
  end

  def build_nginx_config(key, value)
    return "fastcgi_param #{key.upcase} \"#{value}\";\n"
  end

  def get_cluster_name(node = self.node)
    if node[:scalarium]
      return node[:scalarium][:cluster][:name]
    end
    if node[:opsworks] && node[:opsworks][:stack]
      return node[:opsworks][:stack][:name]
    end
    if node[:easybib] && node[:easybib][:cluster_name]
      return node[:easybib][:cluster_name]
    end
    ::Chef::Log.error("Unknown environment.")

    return ""

  end

  def get_deploy_user(node = self.node)
    if node[:scalarium]
      return node[:scalarium][:deploy_user]
    end
    if node[:opsworks]
      return node[:opsworks][:deploy_user]
    end
    ::Chef::Log.debug("Unknown environment.")
  end

  def get_instance_roles(node = self.node)
    if node[:scalarium]
      return node[:scalarium][:instance][:roles]
    end
    if node[:opsworks]
      return node[:opsworks][:instance][:layers]
    end
    ::Chef::Log.debug("Unknown environment.")
  end

  def get_instance(node = self.node)
    if node[:scalarium]
      return node[:scalarium][:instance]
    end
    if node[:opsworks]
      return node[:opsworks][:instance]
    end
    ::Chef::Log.debug("Unknown environment.")
  end

  def is_aws(node = self.node)
    if node[:scalarium]
      return true
    end
    if node[:opsworks]
      return true
    end
    return false
  end

  extend self
end

class Chef::Recipe
  include EasyBib
end
