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
        'deployed_application' => get_appdata(node, appname),
        'deployed_stack' => get_stackdata(node),
        'settings' => streamline_appenv(node['deploy'][appname]['env'])
      }
      to_configformat(format, data)
    end

    def to_configformat(format, data)
      fail "No Config supplied" if data.nil?
      config = generate_start(format)
      data.each_pair do |main_section, section_data|
        Chef::Log.info("Config: Processing section #{main_section}")
        config << generate_section_start(format, main_section)
        config << generate_config_part(format, main_section, section_data)
        config << generate_section_end(format, main_section)
      end
      config << generate_end(format)
    end

    protected

    def get_appdata(node, appname)
      data = {}
      data['appname'] = node['deploy'][appname]['application']
      data['domains'] = node['deploy'][appname]['domains'].join(',')
      if ::EasyBib.is_aws(node)
        data['deploy_dir'] = node['deploy'][appname]['deploy_to']
        data['app_dir'] = node['deploy'][appname]['deploy_to'] + '/current/'
      else
        if node['vagrant'].exists? && node['vagrant']['deploy_to'].exists? && node['vagrant']['deploy_to'][appname].exists?
          data['deploy_dir'] = data['app_dir'] = node['vagrant']['deploy_to'][appname]
        else
          data['deploy_dir'] = data['app_dir'] = '/vagrant_data'
        end
      end
      data
    end

    def get_stackdata(node)
      data = {}
      data['stackname'] = node['opsworks']['stack']['name']
      data['environment'] = node['easybib_deploy']['envtype']
      data
    end

    # generate top of file
    def generate_start(format)
      case format
      when "php"
        "<?php\n$deploy_config = array(\n"
      else
        ""
      end
    end

    # generate end of file
    def generate_end(format)
      case format
      when "php"
        ");"
      else
        ""
      end
    end

    # generates the section header
    def generate_section_start(format, main_section)
      case format
      when "php"
        "  '#{main_section}' => array(\n"
      when "ini"
        "[#{main_section}]\n"
      else
        ""
      end
    end

    # generates the section footer
    def generate_section_end(format, main_section)
      case format
      when "php"
        "  ),\n"
      else
        ""
      end
    end

    def generate_config_part(format, section, section_data)
      config = ""
      section_data.each_pair do |config_key, config_value|
        fail "section_data for #{config_key} is not a string - generate_config_part is not recursive, this wont work!" unless config_value.is_a?(String)
        config << build_config(format, config_key, config_value, section)
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

    def build_config(format, var, value, section = nil)
      case format
      when "nginx"
        build_nginx_config(var, value, section)
      when "shell"
      when "sh"
        build_shell_config(var, value, section)
      when "ini"
        build_ini_config(var, value, section)
      when "php"
        build_php_config(var, value, section)
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

    def build_php_config(key, value, section = nil)
      "    '#{key}'=>\"#{value}\",\n"
    end

    def build_shell_config(key, value, section = nil)
      key = sprintf('%s_%s', section.upcase, key.upcase) if ['deployed_application', 'deployed_stack'].include?(section)
      "export #{key}=\"#{value}\"\n"
    end

    def build_nginx_config(key, value, section = nil)
      key = sprintf('%s_%s', section.upcase, key.upcase) if ['deployed_application', 'deployed_stack'].include?(section)
      "fastcgi_param #{key} \"#{value}\";\n"
    end

    def build_ini_config(key, value, section = nil)
      "#{key} = \"#{value}\"\n"
    end
  end
end
