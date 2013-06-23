module EasyBib

  def amd64?(node = self.node)
    if node[:kernel][:machine] == "x86_64"
      return true
    end
    return false
  end

  def get_db_conf(node_attribute, node = self.node)

    db_conf = ""

    if !node.attribute?(node_attribute)
      return db_conf
    end

    env_config = node[node_attribute]
    if env_config["database"].nil? || env_config["database"].empty?
      return db_conf
    end

    env_config["database"].each do |connection_id,connection_config|
      connection_config.each do |connection_config_key,connection_config_value|
        db_conf << "fastcgi_param"
        db_conf << " #{connection_id.upcase}_#{connection_config_key.upcase}"
        db_conf << " \"#{connection_config_value}\";"
        db_conf << "\n"
      end
    end

    return db_conf
  end

  def get_cluster_name(node = self.node)
    if node[:scalarium]
      return node[:scalarium][:cluster][:name]
    end
    if node[:opsworks]
      return node[:opsworks][:stack][:name]
    end
    ::Chef::Log.debug("Unknown environment.")
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
