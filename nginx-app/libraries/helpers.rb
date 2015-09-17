module NginxApp
  class Helpers
    def self.merge_alias_config(merged_alias_config, alias_config, prefix, app_dir, module_path = 'app/modules')
      module_path << '/' unless module_path.end_with?('/')
      app_dir << '/' unless app_dir.end_with?('/')

      alias_config.each do |urialias, dir|
        merged_alias_config["#{prefix}/#{urialias}"] = "#{app_dir}#{module_path}#{dir}"
      end
      merged_alias_config
    end

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
