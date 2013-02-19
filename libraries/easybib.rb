module Easybib
  def get_cluster_name
    if node[:scalarium]
      return node[:scalarium][:cluster][:name]
    end
    if node[:opsworks]
      return node[:opsworks][:stack][:name]
    end
    ::Chef::Log.debug("Unknown environment.")
  end

  def get_deploy_user
    if node[:scalarium]
      return node[:scalarium][:deploy_user]
    end
    if node[:opsworks]
      return node[:opsworks][:deploy_user]
    end
    ::Chef::Log.debug("Unknown environment.")
  end

  def get_instance_roles
    if node[:scalarium]
      return node[:scalarium][:instance][:roles]
    end
    if node[:opsworks]
      return node[:opsworks][:instance][:layers]
    end
    ::Chef::Log.debug("Unknown environment.")
  end

  def get_instance
    if node[:scalarium]
      return node[:scalarium][:instance]
    end
    if node[:opsworks]
      return node[:opsworks][:instance]
    end
    ::Chef::Log.debug("Unknown environment.")
  end

  def is_aws()
    if node[:scalarium]
      return true
    end
    if node[:opsworks]
      return true
    end
    return false
  end
end

class Chef::Recipe
  include EasyBib
end
