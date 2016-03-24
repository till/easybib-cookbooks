module StackEasyBib
  class Helpers
    def self.merge_alias_config(node, app_dir, module_path = 'app/modules')
      merged_alias_config = {}
      module_path << '/' unless module_path.end_with?('/')
      app_dir << '/' unless app_dir.end_with?('/')

      {
        :js => node['nginx-app']['js_modules'],
        :images => node['nginx-app']['img_modules'],
        :css => node['nginx-app']['css_modules']
      }.each do |prefix, alias_config|
        alias_config.each do |uri_alias, dir|
          merged_alias_config["#{prefix}/#{uri_alias}"] = "#{app_dir}#{module_path}#{dir}"
        end
      end

      merged_alias_config
    end
  end
end
