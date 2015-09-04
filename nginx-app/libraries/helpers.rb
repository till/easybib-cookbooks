module NginxApp
  class Helpers
    def self.uncached_static_extensions(caching_config, static_extensions = %w(jpg jpeg gif png css js ico woff ttf eot))
      return static_extensions if caching_config.nil?

      if caching_config['enabled']
        caching_config['config'].each do |key, value|
          key.split('|').each do |ext|
            static_extensions.delete(ext)
          end
        end
      end
      static_extensions
    end
  end
end
