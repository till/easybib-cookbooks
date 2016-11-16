module EasyBib
  module Config
    extend self

    # returns only the environment settings in the json
    def get_env(format, app, node = self.node)
      return '' unless node.attribute?(app)

      if node[app]['env'].nil?
        Chef::Log.info("Attribute 'env' for application '#{app}' is not defined!")
        return ''
      end

      appenv = streamline_appenv(node[app]['env'])
      generate_config_part(format, 'settings', appenv)
    end

    # returns env settings and information about the stack, application env, and rds
    def get_configcontent(format, appname, node = self.node, stackname = 'getcourse')
      settings = {}
      unless node.fetch(stackname, {})['env'].nil?
        Chef::Log.info("env settings for stack #{stackname} found")
        settings = streamline_appenv(node[stackname]['env'])
      end
      if node.attribute?(appname) && node[appname].attribute?('env')
        Chef::Log.info("env settings for app #{appname} found")
        settings.merge!(streamline_appenv(node[appname]['env']))
      end
      Chef::Log.info("no env settings found - appname was #{appname}, stack #{stackname}") if settings.empty?

      unless node.fetch('deploy', {}).fetch(appname, {}).fetch('database', {})['host'].nil?
        # add configuration from the RDS resource management in opsworks
        Chef::Log.info('found configured rds resource, adding to envvars')
        dbconfig = streamline_appenv('db' => node['deploy'][appname]['database'])
        dbconfig = append_database_url_to_dbconfig(dbconfig)

        settings.merge!(dbconfig)
      end

      puma_config = streamline_appenv('puma' => node.fetch('stack-cmbm', {}).fetch('puma', {}))
      settings.merge!(puma_config)

      data = {
        'deployed_application' => get_appdata(node, appname),
        'deployed_stack' => get_stackdata(node),
        'settings' => settings
      }
      to_configformat(format, data)
    end

    # returns domains for appname
    def get_domains(node, appname)
      domains = ::WT::Data::Injector.get_apps_to_deploy(node).fetch(appname, {})['domains']
      return domains.join(' ') if domains.respond_to?('join')
      domains
    end

    # returns application metadata (name, domains, directories)
    def get_appdata(node, appname)
      application_info = ::WT::Data::Injector.get_apps_to_deploy(node)[appname]
      data = {}
      data['appname'] = application_info['application'].nil? ? appname : application_info['application']
      data['domains'] = get_domains(node, appname)
      data['deploy_dir'] = application_info['deploy_to']
      data['app_dir'] = ::EasyBib.is_aws(node) ? "#{application_info['deploy_to']}/current/" : application_info['deploy_to']
      data['doc_root_dir'] = "#{data['app_dir']}#{application_info['document_root']}"

      # ensure all dirs end with a slash:
      %w(deploy_dir app_dir doc_root_dir).each do |name|
        data[name] << '/' unless data[name].end_with?('/')
      end
      data
    end

    protected

    # returns stack metadata (name, environment-type)
    def get_stackdata(node, attribute = nil)
      data = {}

      data['environment'] = node['easybib_deploy']['envtype']

      if ::EasyBib.is_aws(node)
        data['stackname'] = node['opsworks']['stack']['name']
      elsif node['vagrant']
        data['stackname'] = 'vagrant'
        data['environment'] = 'vagrant'
      else
        data['stackname'] = 'undefined'
      end

      return data[attribute] unless attribute.nil?

      data
    end

    # converts hash in a string, formatted as envvars, php, ini
    def to_configformat(format, data)
      raise 'No Config supplied' if data.nil?
      config = generate_start(format)
      data.each_pair do |main_section, section_data|
        Chef::Log.info("Config: Processing section #{main_section}")
        config << generate_section_start(format, main_section)
        config << generate_config_part(format, main_section, section_data)
        config << generate_section_end(format, main_section)
      end
      config << generate_end(format)
    end

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
        unless config_value.is_a?(String) || config_value.is_a?(Array)
          raise "section_data for #{config_key} is not a string or an array!"
        end
        config << build_config(format, config_key, config_value, section)
      end
      config
    end

    def streamline_appenv(data, prefix = '')
      returnparam = {}
      return returnparam if data.nil?

      data.each_pair do |section, part_data|
        section = get_returnparam_identifier(section, prefix)
        content = get_returnparam(section, part_data)

        returnparam.merge!(content)
      end
      returnparam
    end

    def get_returnparam_identifier(section, prefix)
      return sprintf('%s_%s', prefix, section.upcase) if prefix != ''
      section.upcase
    end

    def get_returnparam(section, part_data)
      if part_data.is_a?(Hash)
        return streamline_appenv(part_data, section)
      elsif part_data.is_a?(Array)
        return { section => part_data }
      elsif part_data.is_a?(String)
        return { section => part_data }
      elsif part_data.respond_to?('to_s')
        return { section => part_data.to_s }
      end

      raise "I have no idea how to deal with config item #{section}."
    end

    def build_config(format, var, value, section = nil)
      validate_value(value)

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
        raise "Unknown configuration type: #{format}."
      end
    end

    def validate_value(value)
      if value.is_a?(String)
        raise 'The character " is not supported as a value in the config' if value.match('"')
        raise "The character \' is not supported as a value in the config" if value.match("'")
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

    private

    def build_php_config(key, value, section = nil)
      if value.is_a?(Array)
        value = value.join("', '")
        return "    '#{key}'=> ['#{value}'],\n"
      end
      "    '#{key}'=>'#{value}',\n"
    end

    def build_shell_config(key, value, section = nil)
      key = sprintf('%s_%s', section.upcase, key.upcase) if %w(deployed_application deployed_stack).include?(section)
      if value.is_a?(Array)
        returnvalue = ''
        array_to_numbered_hash(key, value).each do |sub_key, item|
          returnvalue << "export #{sub_key}=\"#{item}\"\n"
        end
        return returnvalue
      end
      "export #{key}=\"#{value}\"\n"
    end

    def build_nginx_config(key, value, section = nil)
      key = sprintf('%s_%s', section.upcase, key.upcase) if %w(deployed_application deployed_stack).include?(section)
      if value.is_a?(Array)
        returnvalue = ''
        array_to_numbered_hash(key, value).each do |sub_key, item|
          returnvalue << "fastcgi_param #{sub_key} \"#{item}\";\n"
        end
        return returnvalue
      end
      "fastcgi_param #{key} \"#{value}\";\n"
    end

    def build_ini_config(key, value, section = nil)
      if value.is_a?(Array)
        returnvalue = ''
        array_to_numbered_hash(key, value).each do |sub_key, item|
          returnvalue << "#{sub_key} = \"#{item}\"\n"
        end
        return returnvalue
      end
      "#{key} = \"#{value}\"\n"
    end

    def array_to_numbered_hash(key, arr)
      i = 0
      ret = {}
      arr.each do |item|
        subkey = sprintf('%s[%s]', key, i)
        ret[subkey] = item
        i += 1
      end
      ret
    end

    def recursive_fetch(hash, keys)
      begin
        retval = keys.reduce(hash, :fetch)
      rescue KeyError
        retval = nil
      end
      retval
    end

    def append_database_url_to_dbconfig(dbconfig)
      return unless dbconfig

      return dbconfig unless dbconfig['DB_DATABASE']
      return dbconfig unless dbconfig['DB_HOST']
      return dbconfig unless dbconfig['DB_PORT']
      return dbconfig unless dbconfig['DB_USERNAME']
      return dbconfig unless dbconfig['DB_PASSWORD']

      db_type = dbconfig['DB_TYPE'] == 'mysql' ? 'mysql2' : dbconfig['DB_TYPE']

      db_url = "#{db_type}://#{dbconfig['DB_USERNAME']}:#{dbconfig['DB_PASSWORD']}@" \
               "#{dbconfig['DB_HOST']}:#{dbconfig['DB_PORT']}/" \
               "#{dbconfig['DB_DATABASE']}?reconnect=#{dbconfig['DB_RECONNECT']}"

      dbconfig['DATABASE_URL'] = db_url

      dbconfig
    end
  end
end

Chef::Provider.send(:include, ::EasyBib::Config)
Chef::Recipe.send(:include, ::EasyBib::Config)
Chef::Resource.send(:include, ::EasyBib::Config)
