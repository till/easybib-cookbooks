module IesRoute53
  module Helper
    def get_aws_config(node = self.node)
      config = get_zone_config(node)

      {
        :access_key => config.fetch('custom_access_key', nil),
        :secret => config.fetch('custom_secret_key', nil),
        :zone_id => config.fetch('id', nil)
      }
    end

    def dns_enabled?(node = self.node)
      zone_config = get_zone_config(node)

      # custom_access_key & custom_secret_key are optional
      %w(id).each do |attrib|
        unless zone_config.key?(attrib)
          return false
        end

        if zone_config[attrib].empty? || zone_config[attrib].nil?
          return false
        end
      end

      true
    end

    private

    def get_zone_config(node)
      node.fetch('ies-route53', {}).fetch('zone', {})
    end
  end
end

Chef::Provider.send(:include, ::IesRoute53::Helper)
Chef::Recipe.send(:include, ::IesRoute53::Helper)
Chef::Resource.send(:include, ::IesRoute53::Helper)
