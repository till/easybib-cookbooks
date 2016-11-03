module WT
  module Data
    class NodeObject
      attr_reader :resource_data

      def initialize(resource)
        @original_resource = resource
        @resource_data = Hash[cleanup(resource)]
      end

      def [](attrib)
        attrib = attrib.to_s if attrib.is_a?(Symbol)
        return @resource_data[attrib] if @resource_data.key?(attrib)
        fallback(attrib)
      end

      def to_json
        JSON.pretty_generate(resource_data)
      end

      protected

      def cleanup(resource)
      end

      # this is something we should eventually remove - but lets keep it here for now so that we dont break chef runs
      # with this new class, and instead get a log warning that we need to add something to the map:
      def fallback(key)
        Chef::Log.warn("WT::Data::NodeObject: There is #{key} nil in the generated obj, falling back to old data")
        @original_resource[key]
      end
    end

    class AppObject < NodeObject
      def cleanup(resource)
        if resource.is_a?(Chef::Node::ImmutableMash)
          return cleanup_chef11(resource)
        elsif resource.is_a?(Chef::DataBagItem)
          return cleanup_chef12(resource)
        else
          raise 'Unknown resource'
        end
      end

      def cleanup_chef12(resource)
        Chef::Log.info(resource.inspect)
        map = {
          'app_id' => 'chef_12_app_id',
          'shortname' => 'application',
          'data_sources' => 'database', # + databag fetch
          'domains' => 'domains',
          'environment' => 'environment',
          'app_source' => 'scm'
        }

        cleaned = {}
        map.each do |source, target|
          cleaned[target] = if resource[source]
                              resource[source]
                            end
        end

        # XXX TODO user, group
        cleaned['ssl_certificate'] = resource['ssl_configuration']['certificate']
        cleaned['ssl_certificate_ca'] = resource['ssl_configuration']['chain']
        cleaned['ssl_certificate_key'] = resource['ssl_configuration']['private_key']
        cleaned['document_root'] = resource['attributes']['document_root']
        cleaned['deploy_to'] = 'TODO'
        raise 'Warning: You were trying to use the data wrapper function with chef 12. This is not supported/tested/finished yet.'
        # cleaned
      end

      def cleanup_chef11(resource)
        # only those we actually use
        map = {
          'application' => 'application',
          'database' => 'database',
          'deploy_to' => 'deploy_to',
          'document_root' => 'document_root',
          'domains' => 'domains',
          'environment' => 'environment',
          'scm' => 'scm',
          'ssl_certificate' => 'ssl_certificate',
          'ssl_certificate_ca' => 'ssl_certificate_ca',
          'ssl_certificate_key' => 'ssl_certificate_key',
          'ssl_support' => 'ssl_support',
          'user' => 'user',
          'group' => 'group',
          'home' => 'home',
          'shell' => 'shell'
        }

        cleaned = {}
        map.each do |source, target|
          cleaned[target] = if resource[source]
                              resource[source]
                            end
        end
        cleaned
      end
    end
  end
end
