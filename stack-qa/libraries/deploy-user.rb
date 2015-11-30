module StackQa
  class DeployUser
    def initialize(node)
      set_node(node)
    end

    def get_home
      deploy_user_name = get_user

      case deploy_user_name
      when 'www-data'
        return '/var/www'
      when 'root'
        return '/root'
      else
        "/home/#{deploy_user_name}"
      end
    end

    def get_role
      @node['stack-qa']['deploy_role']
    end

    def get_user
      deploy_role = get_role

      fail ArgumentError, 'no deploy_user' unless @node['stack-qa'][deploy_role].key?('deploy_user')
      @node['stack-qa'][deploy_role]['deploy_user']
    end

    private

    def set_node(node)
      fail ArgumentError, 'no stack-qa set' unless node.key?('stack-qa')

      fail ArgumentError, 'no deploy_role' unless node['stack-qa'].key?('deploy_role')

      @node = node
    end
  end
end
