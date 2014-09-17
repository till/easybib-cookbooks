module EasyBib
  module Config
    extend self
    def get_env(format, app, node = self.node)
      config = ''

      unless node.attribute?(app)
        return config
      end

      if node[app]['env'].nil?
        fail "Attribute 'env' for application '#{app}' is not defined!"
      end
      # TODO: This should use streamline_appenv
      node[app]['env'].each_pair do |section, data|
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

    def get_configcontent(format, appname, node = self.node, stackname = 'getcourse')
      settings = {}
      if node.attribute?(appname) && node[appname].attribute?('env')
        Chef::Log.info("env settings for app #{appname} found")
        settings = streamline_appenv(node[appname]['env'])
      elsif !node.fetch(stackname, {})['env'].nil?
        Chef::Log.info("env settings for stack #{stackname} found")
        settings = streamline_appenv(node[stackname]['env'])
      else
        Chef::Log.info('no env settings found')
      end

      unless node.fetch('deploy', {}).fetch(appname, {})['database'].nil?
        # add configuration from the RDS resource management in opsworks
        dbconfig = streamline_appenv('db' => node['deploy'][appname]['database'])
        settings.merge!(dbconfig)
      end

      data = {
        'deployed_application' => get_appdata(node, appname),
        'deployed_stack' => get_stackdata(node),
        'settings' => settings
      }
      to_configformat(format, data)
    end

    def to_configformat(format, data)
      fail 'No Config supplied' if data.nil?
      config = generate_start(format)
      data.each_pair do |main_section, section_data|
        Chef::Log.info("Config: Processing section #{main_section}")
        config << generate_section_start(format, main_section)
        config << generate_config_part(format, main_section, section_data)
        config << generate_section_end(format, main_section)
      end
      config << generate_end(format)
    end

    def get_vagrant_appdir(node, appname)
      if ::EasyBib.is_aws(node)
        Chef::Log.warn('get_vagrant_appdir called from AWS env. There is something broken.')
        # trying to return a somewhat sane default
        return node['deploy'][appname]['deploy_to']
      end

      has_docroot_location = !node.fetch('vagrant', {}).fetch('applications', {}).fetch(appname, {})['doc_root_location'].nil?
      has_approot_location = !node.fetch('vagrant', {}).fetch('applications', {}).fetch(appname, {})['app_root_location'].nil?

      if has_approot_location
        return node['vagrant']['applications'][appname]['app_root_location']
      elsif !has_docroot_location
        Chef::Log.info('neither app_root_location nor doc_root_location set. Locations set to vagrant default')
        return '/vagrant_data/'
      end

      Chef::Log.info('app_root_location is not set in web_dna.json, trying to guess')
      path = node['vagrant']['applications'][appname]['doc_root_location']
      '/' + path.split('/')[1..-2].join('/') + '/'
    end

    def get_domains(node, appname, env = 'getcourse')
      unless node.fetch('deploy', {}).fetch(appname, {})['domains'].nil?
        return node['deploy'][appname]['domains'].join(' ')
      end

      unless node.fetch('vagrant', {}).fetch('applications', {}).fetch(appname, {})['domain_name'].nil?
        domains = node['vagrant']['applications'][appname]['domain_name']
        if domains.is_a?(String)
          return domains
        else
          return domains.join(' ')
        end
      end

      unless node.fetch(env, {}).fetch('domain', {})[appname].nil?
        Chef::Log.warn("Using old node[#{env}]['domain'][appname] domain config")
        if (env == 'getcourse') && (appname == 'consumer')
          # workaround to use old domain config syntax for consumer here, too
          # deprecated, and soon to be removed.
          return "#{node[env]['domain'][appname]} *.#{node[env]['domain'][appname]}"
        end
        return node[env]['domain'][appname]
      end

      ''
    end

    def get_appdata(node, appname)
      data = {}
      if node.fetch('deploy', {}).fetch(appname, {})['application'].nil?
        data['appname'] = appname
      else
        data['appname'] = node['deploy'][appname]['application']
      end

      data['domains'] = get_domains(node, appname)

      if ::EasyBib.is_aws(node)
        data['deploy_dir'] = node['deploy'][appname]['deploy_to']
        data['app_dir'] = node['deploy'][appname]['deploy_to'] + '/current/'
        data['doc_root_dir'] = "#{data['app_dir']}#{node['deploy'][appname]['document_root']}"
      else
        data['deploy_dir'] = data['app_dir'] = get_vagrant_appdir(node, appname)
        data['doc_root_dir'] = node['vagrant']['applications'][appname]['doc_root_location']
      end

      # ensure all dirs end with a slash:
      %w(deploy_dir app_dir doc_root_dir).each do |name|
        data[name] << '/' unless data[name].end_with?('/')
      end

      data
    end

    def get_stackdata(node)
      data = {}
      if ::EasyBib.is_aws(node)
        data['stackname'] = node['opsworks']['stack']['name']
      elsif node['vagrant']
        data['stackname'] = 'vagrant'
      else
        data['stackname'] = 'undefined'
      end
      data['environment'] = node['easybib_deploy']['envtype']
      data
    end

    protected

    # generate top of file
    def generate_start(format)
      case format
      when 'php'
        "<?php\nreturn [\n"
      else
        ''
      end
    end

    # generate end of file
    def generate_end(format)
      case format
      when 'php'
        '];'
      else
        ''
      end
    end

    # generates the section header
    def generate_section_start(format, main_section)
      case format
      when 'php'
        "  '#{main_section}' => [\n"
      when 'ini'
        "[#{main_section}]\n"
      else
        ''
      end
    end

    # generates the section footer
    def generate_section_end(format, main_section)
      case format
      when 'php'
        "  ],\n"
      else
        ''
      end
    end

    def generate_config_part(format, section, section_data)
      config = ''
      section_data.each_pair do |config_key, config_value|
        fail "section_data for #{config_key} is not a string - generate_config_part is not recursive, this wont work!" unless config_value.is_a?(String)
        config << build_config(format, config_key, config_value, section)
      end
      config
    end

    def streamline_appenv(data, prefix = '')
      returnparam = {}
      return returnparam if data.nil?
      data.each_pair do |section, part_data|

        if prefix != ''
          section = sprintf('%s_%s', prefix, section.upcase)
        else
          section = section.upcase
        end

        if part_data.is_a?(Hash)
          returnparam.merge!(streamline_appenv(part_data, section))
        elsif part_data.is_a?(String)
          returnparam[section] = part_data
        elsif part_data.respond_to?('to_s')
          returnparam[section] = part_data.to_s
        else
          fail "I have no idea how to deal with config item #{section}."
        end
      end
      returnparam
    end

    def build_config(format, var, value, section = nil)
      case format
      when 'nginx'
        build_nginx_config(var, value, section)
      when 'shell'
        build_shell_config(var, value, section)
      when 'sh'
        build_shell_config(var, value, section)
      when 'ini'
        build_ini_config(var, value, section)
      when 'php'
        build_php_config(var, value, section)
      else
        fail "Unknown configuration type: #{format}."
      end
    end

    def get_output(data, format)
      config = ''
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
      key = sprintf('%s_%s', section.upcase, key.upcase) if %w(deployed_application deployed_stack).include?(section)
      "export #{key}=\"#{value}\"\n"
    end

    def build_nginx_config(key, value, section = nil)
      key = sprintf('%s_%s', section.upcase, key.upcase) if %w(deployed_application deployed_stack).include?(section)
      "fastcgi_param #{key} \"#{value}\";\n"
    end

    def build_ini_config(key, value, section = nil)
      "#{key} = \"#{value}\"\n"
    end
  end
end
