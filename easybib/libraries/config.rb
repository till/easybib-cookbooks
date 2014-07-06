module EasyBib
  module Config
    extend self
    def get_env(format, app, node = self.node)
      config = ""

      if !node.attribute?(app)
        return config
      end

      if node[app]["env"].nil?
        fail "Attribute 'env' for application '#{app}' is not defined!"
      end
      # TODO: This should use streamline_appenv
      node[app]["env"].each_pair do |section, data|
        data.each_pair do |config_key, config_value|
          if config_value.is_a?(String)

            fail "The character \" is not supported as a value in the config" if config_value.match('"')
            var = sprintf('%s_%s', section.upcase, config_key.upcase)
            config << build_config(format, var, config_value)
            next
          end

          config_value.each_pair do |sub_key, sub_value|
            var = sprintf('%s_%s_%s', section.upcase, config_key.upcase, sub_key.upcase)
            fail "The character \" is not supported as a value in the config" if sub_value.match('"')
            config << build_config(format, var, sub_value)
          end
        end
      end

      config
    end

    def get_configcontent(format, appname, node = self.node)
      fail "No Config for #{appname}" if node['deploy'][appname].nil?
      data = {
        'deployed_application' => {
          'appname' => node['deploy'][appname]['application'],
          'domains' => node['deploy'][appname]['domains'].join(','),
          'deploy_dir' => node['deploy'][appname]['deploy_to']
        },
        'deployed_stack' => {
          'stackname' => node['opsworks']['stack']['name'],
          'environment' => node['easybib_deploy']['envtype']
        },
        'settings' => streamline_appenv(node['deploy'][appname]['env'])
      }
      to_configformat(format, data)
    end

    def to_configformat(format, data)
      fail "No Config supplied" if data.nil?
      config = ""
      data.each_pair do |main_section, section_data|
        config << generate_header(format, main_section)
        config << generate_config_part(format, section_data)
      end
      config
    end

    protected

    # generates the section header, currently only for ini format
    def generate_header(format, main_section)
      case format
      when "ini"
        "[#{main_section}]\n"
      else
        ""
      end
    end

    def generate_config_part(format, section_data)
      config = ""
      section_data.each_pair do |config_key, config_value|
        fail "section_data is not a string - generate_config_part is not recursive, this wont work!" unless config_value.is_a?(String)
        config << build_config(format, config_key, config_value)
      end
      config
    end

    def streamline_appenv(data)
      returnparam = {}
      return returnparam if data.nil?
      data.each_pair do |section, part_data|
        part_data.each_pair do |config_key, config_value|
          if config_value.is_a?(String)
            fail "The character \" is not supported as a value in the config" if config_value.match('"')
            var = sprintf('%s_%s', section.upcase, config_key.upcase)
            returnparam[var] = config_value
            next
          end

          config_value.each_pair do |sub_key, sub_value|
            var = sprintf('%s_%s_%s', section.upcase, config_key.upcase, sub_key.upcase)
            fail "The character \" is not supported as a value in the config" if sub_value.match('"')
            returnparam[var] = sub_value
          end
        end
      end
      returnparam
    end

    def build_config(format, var, value)
      case format
      when "nginx"
        build_nginx_config(var, value)
      when "shell"
        build_shell_config(var, value)
      when "ini"
        build_ini_config(var, value)
      else
        fail "Unknown configuration type: #{format}."
      end
    end

    def get_output(data, format)
      config = ""
      data.each_pair do |config_key, config_value|
        config << build_config(format, config_key, config_value)
        next
      end
      config
    end

    def build_shell_config(key, value)
      "export #{key}=\"#{value}\"\n"
    end

    def build_nginx_config(key, value)
      "fastcgi_param #{key} \"#{value}\";\n"
    end

    def build_ini_config(key, value)
      "#{key} = \"#{value}\"\n"
    end
  end
end
