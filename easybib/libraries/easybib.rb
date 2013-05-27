module EasyBib

  def amd64?(node = self.node)
    if node[:kernel][:machine] == "x86_64"
      return true
    end
    return false
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
