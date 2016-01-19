module IesRoute53
  module Helper
    def dns_enabled?(node = self.node)
      zone_config = node.fetch('ies-route53', {}).fetch('zone', {})

      %w(id custom_access_key custom_secret_key).each do |attrib|
        unless zone_config.key?(attrib)
          return false
        end

        if zone_config[attrib].empty? || zone_config[attrib].nil?
          return false
        end
      end

      true
    end
  end
end

Chef::Provider.send(:include, ::IesRoute53::Helper)
Chef::Recipe.send(:include, ::IesRoute53::Helper)
Chef::Resource.send(:include, ::IesRoute53::Helper)
